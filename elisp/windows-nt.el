(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "SystemWindow" :foreground "SystemWindowText" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "outline" :family "Consolas")))))
(setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))
(setq exec-path (cons "c:/cygwin/bin/" exec-path))

;; (require 'cygwin-mount)
;; (cygwin-mount-activate)

(add-hook 'comint-output-filter-functions
	  'shell-strip-ctrl-m nil t)
(add-hook 'comint-output-filter-functions
	  'comint-watch-for-password-prompt nil t)

;; For subprocesses invoked via the shell
;; (e.g., "shell -c command")
(setq explicit-shell-file-name "bash")
(setq shell-file-name explicit-shell-file-name)
