;; library, auto-save, backup paths
(setq backup-directory-alist (quote ((".*" . "~/.emacs.mine/"))))
(setq tramp-auto-save-directory "~/.emacs.mine/")
(add-to-list 'load-path "~/emacs_configuration/elisp")

;; system-dependent setup and latex
(add-hook 'latex-mode-hook '(lambda ()
			      (load-library "latex-compile-preview")))
(add-hook 'c-mode-common-hook '(lambda ()
				 (column-marker-1 80)))
(load-library (symbol-name system-type))

;; vim-like include file search, uses local shell and grep
(autoload 'search-this-word-in-headers "include-finder" nil t nil)
(autoload 'add-path "include-finder" nil t nil)

(require 'saveplace)
(setq-default save-place t)

;; misc
(setq ring-bell-function 'ignore)
(add-to-list 'auto-mode-alist '("\\.str$" . c++-mode))
(global-set-key (kbd "RET") 'newline-and-indent)
(add-hook 'dired-mode-hook '(lambda () (local-set-key [mouse-2] 'dired-find-file)))
(autoload 'column-marker-1 "column-marker" "Highlight a column." t)
(setq desktop-files-not-to-save "^$")
(setq c-default-style "linux" c-basic-offset 8)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; cscope stuff
(if (featurep 'xcscope)
      (setq cscope-do-not-update-database t))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("/sat:/u/yyetim/notes.org")))
 '(recentf-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(which-function-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
