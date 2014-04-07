;; Yavuz Yetim
;; Assumes a Makefile that produces main.pdf
;; Compile with make using C-c and display using C-p
;;   on cygwin use adobe to display file
;;   on linux use evince
;;   on darwin use open

(setq local-pdf-viewer
      (cond
       ((eq 'windows-nt system-type)
	"/cygdrive/c/Program\\ Files\\ \\(x86\\)/Adobe/Reader\\ 10.0/Reader/AcroRd32.exe")
       ((eq 'gnu/linux system-type) "evince")
       ((eq 'darwin system-type) "open")))

(require 'dired)
(global-set-key (kbd "C-c p")
		'(lambda ()
		   (interactive)
		   (dired-copy-file (concat default-directory "main.pdf") (concat temporary-file-directory "main.pdf") t)
		   (start-process-shell-command
		    "latex-preview" "*latex-preview*"
		    (concat local-pdf-viewer " " temporary-file-directory "main.pdf"))))

(global-set-key (kbd "C-c c") '(lambda ()
				 (interactive)
				 (compile "make")
				 (switch-to-buffer-other-window "*compilation*")
				 (goto-char (point-max))))

(global-set-key (kbd "C-c k") '(lambda ()
				 (interactive)
				 (compile "make clean && make")
				 (switch-to-buffer-other-window "*compilation*")
				 (goto-char (point-max))))
(visual-line-mode 1)
(flyspell-mode 1)
(flyspell-buffer)
