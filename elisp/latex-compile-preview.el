;; Yavuz Yetim
;; Assumes a Makefile that produces main.pdf
;; Compile with make
;;   on cygwin use adobe to display file
;;   on linux use xdg-open
;;   on darwin use open

(if (eq 'windows-nt system-type)
    (setq local-pdf-viewer "/cygdrive/c/Program\\ Files\\ \\(x86\\)/Adobe/Reader\\ 10.0/Reader/AcroRd32.exe")
  (if (eq 'gnu/linux system-type)
      (setq local-pdf-viewer "xdg-open")
    (if (eq 'darwin system-type)
	(setq local-pdf-viewer "open"))))

(require 'dired)
(global-set-key (kbd "C-c p")
		'(lambda ()
		   (interactive)
		   (dired-copy-file (concat default-directory "main.pdf") (concat temporary-file-directory "main.pdf") t)
		   (with-temp-buffer
		     (start-process-shell-command
		      "latex-preview" "*latex-preview*"
		      (concat local-pdf-viewer " " temporary-file-directory "main.pdf")))))

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
