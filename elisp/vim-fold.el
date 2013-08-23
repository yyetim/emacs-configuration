(defun set-vim-foldmarker (fmr)
  "Set Vim-type foldmarkers for the current buffer"
  (interactive "sSet local Vim foldmarker: ")
  (if (equal fmr "")
      (message "Abort")
    (setq fmr (regexp-quote fmr))
    (set (make-local-variable 'outline-regexp)
	 (concat ".*" fmr "\\([0-9]+\\)"))
    (set (make-local-variable 'outline-level)
	 `(lambda ()
	    (save-excursion
	      (re-search-forward
	       ,(concat fmr "\\([0-9]+\\)") nil t)
	      (string-to-number (match-string 1)))))))
(add-hook 'outline-minor-mode-hook
	  (lambda () (local-set-key "\C-c\C-c"
				    outline-mode-prefix-map)))