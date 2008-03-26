;;
;; Support code for LSST PAF files
;;
;; The basic tool is a "paf" mode
;;   (load-file "/path/to/paf.el")
;;   (paf-mode)
;;
;; The following should be put in your .emacs file to automatically
;; load these functions when editing *.paf files
;;
;; (setq auto-mode-alist
;;       (cons (cons "\\.paf$" 'paf-mode) auto-mode-alist))
;; (autoload 'paf-mode "/path/to/paf.el" "Load PAF mode" t)
;;
;; Alternatively, if the first line of a file contains the string
;;		-*- paf -*-
;; emacs will load paf-mode
;;
;; If you want to make TAB re-indent lines and/or
;; syntax-colour your paf files, add this to your .emacs file
;; (you can comment out lines by prepending a ;)
;;
;; (add-hook 'paf-mode-hook
;; 	  '(lambda ()
;; 	     (setq paf-tab-always-indent t) ; make TAB always indent
;;	     (font-lock-mode t)		; enable syntax colouring
;; ))
;;
(defvar paf-indent 4 "*Indentation for blocks.")
(defvar paf-comment-column 40 "*Comments start in this column")
(defvar paf-tab-always-indent nil
  "*Non-nil means TAB in paf mode should always reindent the current line,
regardless of where in the line point is when the TAB command is used.")

(defvar paf-mode-syntax-table nil
  "Syntax table in use in paf-mode buffers.")

(if (not paf-mode-syntax-table)
    (progn 
      (setq paf-mode-syntax-table (make-syntax-table))
      (modify-syntax-entry ?_ "w" paf-mode-syntax-table)
      (modify-syntax-entry ?{ "(}" paf-mode-syntax-table)
      (modify-syntax-entry ?} "){" paf-mode-syntax-table)
      (modify-syntax-entry ?# "<" paf-mode-syntax-table)
      (modify-syntax-entry ?\n ">" paf-mode-syntax-table)))

(defvar paf-mode-map () 
  "Keymap used in PAF mode.")

(if paf-mode-map
    ()
  (setq paf-mode-map (make-sparse-keymap))
;  (define-key paf-mode-map "\t" 'paf-tab)
;  (define-key paf-mode-map "\C-m" 'paf-newline-and-indent)
;  (define-key paf-mode-map "}" 'paf-insert-and-indent)
;  (define-key paf-mode-map "\e\t" 'paf-indent-line)
;  (define-key paf-mode-map "\e;" 'paf-add-comment)
  )

;;
(defun paf-mode (&optional executable-file) "Major mode for editing PAF code.

Variables controlling indentation style and extra features:

 paf-indent                                (default: 4)
    Indentation for blocks.
 paf-comment-column                        (default: 40)
    Starting column for comments following code.
 paf-tab-always-indent                     (default: nil)
    Non-nil means TAB in PAF mode should always reindent the current line,
    regardless of where in the line point is when the TAB command is used.

Turning on PAF mode calls the value of the variable paf-mode-hook 
with no args, if it is non-nil.
\\{paf-mode-map}"
  (interactive "p")
  (kill-all-local-variables)
  (set-syntax-table paf-mode-syntax-table)
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'paf-indent-line)
  (setq indent-tabs-mode nil)
  (make-local-variable 'comment-indent-function)
  (setq comment-indent-function '(lambda () paf-comment-column))
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "[^\\\\]#+[ \t]*")
  (make-local-variable 'comment-start)
  (setq comment-start "# ")
  (setq comment-column paf-comment-column)
  (make-local-variable 'require-final-newline)
  (setq require-final-newline t)
  (make-local-variable 'font-lock-keywords)
  (setq font-lock-keywords paf-font-lock-keywords)
  (use-local-map paf-mode-map)
  (setq mode-name "PAF")
  (setq major-mode 'paf-mode)
  (make-local-variable 'global-mode-string)
  (setq global-mode-string "PAF")
  (run-hooks 'paf-mode-hook))

(add-hook 'font-lock-mode-hook
	  '(lambda () 
	    (if (eq major-mode 'paf-mode)
		(setq font-lock-keywords paf-font-lock-keywords))))


(defun paf-indent-line ()
  "Indent current line based on its contents and on previous lines."
  (interactive)

  (let ( (icol (calculate-paf-indent))
	 (has-comment
	  (save-excursion (beginning-of-line)
			  (search-forward "#" (save-excursion (end-of-line) (point)) t)))
	 )
    (save-excursion
      (beginning-of-line)
      (skip-chars-forward " \t")
      (if (= icol (current-column))
	  t
	(delete-horizontal-space)
	(indent-to-column icol)))
    ;; Put point at start of line that we (may have) reindented
    (beginning-of-line)
    (skip-chars-forward " \t")

    (if has-comment
	(save-excursion (comment-indent)))
    ))

(defun calculate-paf-indent ()
  "Calculates the paf indent column based on previous lines."
  (interactive)
  (let ((icol))
    (save-excursion
      (previous-line 1)
      (while (looking-at "^[ \t]*$")
	(previous-line 1))
      (beginning-of-line)
      (skip-chars-forward " \t")
      (setq icol (current-column))
      ;; Does previous line end with a {?
      (skip-chars-forward "^{#\n")
      (if (looking-at "{")
	  (setq icol (+ icol paf-indent))))
    (save-excursion
      (beginning-of-line)
      (skip-chars-forward "^}#\n")
      (if (looking-at "}")
	  (setq icol (- icol paf-indent))))
    (max 0 icol)))


;;
;; Font lock mode for PAF files
;;
(defconst paf-font-lock-keywords
  (list
       ;; '("#.*" . font-lock-comment-face) ;; this is done automatically
       ;;
       ;; include something
       ;;
       '("\\<include[ \t]*[^ \t]*" . font-lock-comment-face)
       ;;
       ;; Keys (and following :)
       ;;
       '("\\<\\([a-zA-Z0-9_]+\\)\\>:"
	 . font-lock-keyword-face)
       ;;
       ;; string -- "quoted text" and 'strings'
       ;;
       '("\"\\([^\"]*\\)\"" 1 font-lock-string-face)
       '("'\\([^\']*\\)'" 1 font-lock-string-face)
       )
  "Additional expressions to highlight in PAF mode."
  )

