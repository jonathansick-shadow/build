;;
;; Support code for the LSST parasoft C++ coding standards checker
;;
;; Author: rhl@astro.princeton.edu
;;
;; Put a file containing parasoft errors in your product's top level directory,
;; and put it into parasoft-mode:
;;  (load "parasoft")
;;  (parasoft-mode)
;;
;; Then \C-c0    will display the first error from the file in a different window
;;      \C-c\C-n will display the next error
;;      \C-c\C-s will display the error under the cursor
;;
(defvar parasoft-mode-map () 
  "Keymap used in parasoft mode.")

(if parasoft-mode-map
    ()
  (setq parasoft-mode-map (make-sparse-keymap))
  )
  (define-key parasoft-mode-map "\C-c0" 'parasoft-first-transgression)
  (define-key parasoft-mode-map "\C-c\C-n" 'parasoft-next-transgression)
  (define-key parasoft-mode-map "\C-c\C-s" 'parasoft-show-transgression)
;)
;;
(defun parasoft-mode (&optional executable-file)
  "A mode to make fixing parasoft errors a little easier

\\{parasoft-mode-map}"
  (interactive "p")
  (use-local-map parasoft-mode-map)
  (setq mode-name "Parasoft")
  (setq major-mode 'parasoft-mode)
  (make-local-variable 'parasoft-filename)
  (run-hooks 'parasoft-mode-hook))

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

(defun parasoft-first-transgression ()
  "Find first reported transgression"
  (interactive)
  (goto-char (point-min))
  (parasoft-next-transgression))

(defun parasoft-show-transgression ()
  "Show the transgression under the cursor"
  (interactive)

  (beginning-of-line)
  (if (not (looking-at "\\([0-9]+\\):[ \t]+\\([^\t]+\\)"))
      (error "Line doesn't appear to report a sin"))

  (let (
	(lineno (string-to-number (match-string 1)))
	(msg (match-string 2))
	file
	(found-file nil)
	)
    
    (save-excursion
      (if (re-search-backward "^/\\(.*\\)" nil t)
	  (setq parasoft-filename (match-string 1))
	(error "I can't find a filename")))
    (setq file parasoft-filename)
  ;;
  ;; Look for that file, stripping path elements until we find a match
  ;;
  ;; E.g. If the file is meas_algorithms/src/CR.cc and we're in meas/algorithms,
  ;; we'll strip the "meas_algorithms/" and find src/CR.cc
    (while (and file (not found-file))
      (if (file-exists-p file)
	  (progn
	    (find-file-other-window file)
	    (setq found-file t))
	(string-match "^[^/]+/\\(.*\\)" file)
	(setq file (match-string 1 file))
	))
    
    (if (not found-file)
	(error (format "No such file: %s" parasoft-filename)))

    (goto-line lineno)
    (recenter 1)
    
    (message msg)
    )
  )

(defun parasoft-next-transgression ()
  "Show the next transgression"
  (interactive)
  (forward-line 1)
  (beginning-of-line)
  (if (not (looking-at "[0-9]+:\t"))
      (progn
	(re-search-forward "^/")
	(forward-line 1)))
  (parasoft-show-transgression))
