;; library, auto-save, backup paths
(setq backup-directory-alist (quote ((".*" . "~/.emacs.mine/"))))
(setq tramp-auto-save-directory "~/.emacs.mine/")
(add-to-list 'load-path "~/emacs-configuration/elisp")

;; system-dependent setup and latex
(add-hook 'c-mode-common-hook '(lambda ()
				 (load-library "vim-fold")
				 (column-marker-1 80)
				 (set-fill-column 79)
				 (outline-minor-mode 1)
				 (set-vim-foldmarker "{{{")
				 (defun fill-newline() (newline-and-indent))
				 (local-set-key (kbd "M-q") 'fill-region)))
(add-hook 'java-mode-hook '(lambda ()
			     (setq-default c-basic-offset 4)))
(load-library (symbol-name system-type))

;; vim-like include file search, uses local shell and grep
(autoload 'search-this-word-in-headers "include-finder" nil t nil)
(autoload 'add-path "include-finder" nil t nil)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'saveplace)
(setq-default save-place t)

;; windows (redefine switch mappings)
(require 'windows)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)
(global-set-key (kbd "<f1>") '(lambda () (interactive) (win-switch-to-window 1 1)))
(global-set-key (kbd "<f2>") '(lambda () (interactive) (win-switch-to-window 1 2)))
(global-set-key (kbd "<f3>") '(lambda () (interactive) (win-switch-to-window 1 3)))
(global-set-key (kbd "<f4>") '(lambda () (interactive) (win-switch-to-window 1 4)))
(global-set-key (kbd "<f5>") '(lambda () (interactive) (win-switch-to-window 1 5)))
(global-set-key (kbd "<f6>") '(lambda () (interactive) (win-switch-to-window 1 6)))


;; tabbar
;; (require 'tabbar)
;; (tabbar-mode)
;; (load-library "tabbar-config")

;; misc
(setq ring-bell-function 'ignore)
(add-to-list 'auto-mode-alist '("\\.str$" . java-mode))
(global-set-key (kbd "RET") 'newline-and-indent)

;; Easier jumping around the windows
(global-set-key (kbd "C-x O") '(lambda () (interactive) (other-window -1)))
(define-key global-map (kbd "C-x <up>") 'windmove-up)
(define-key global-map (kbd "C-x <down>") 'windmove-down)
(define-key global-map (kbd "C-x <left>") 'windmove-left)
(define-key global-map (kbd "C-x <right>") 'windmove-right)

(add-hook 'dired-mode-hook '(lambda () (local-set-key [mouse-2] 'dired-find-file)))
(autoload 'column-marker-1 "column-marker" "Highlight a column." t)
(setq desktop-files-not-to-save "^$")

;; -diff from commandline
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
	(file2 (pop command-line-args-left)))
    (ediff file1 file2)))

(add-to-list 'command-switch-alist '("diff" . command-line-diff))

;; full-screen
(defvar my-fullscreen-p t "Check if fullscreen is on or off")
(defun my-non-fullscreen ()
    (interactive)
      (if (fboundp 'w32-send-sys-command)
	    ;; WM_SYSCOMMAND restore #xf120
	    (w32-send-sys-command 61728)
	(set-frame-parameter nil 'fullscreen 'fullheight)))
(defun my-fullscreen ()
    (interactive)
      (if (fboundp 'w32-send-sys-command)
	    ;; WM_SYSCOMMAND maximaze #xf030
	    (w32-send-sys-command 61488)
	(progn
	  (setq non-fullscreen-size (frame-parameter nil 'width))
	  (set-frame-parameter nil 'fullscreen 'fullboth))))
(defun my-toggle-fullscreen ()
    (interactive)
      (setq my-fullscreen-p (not my-fullscreen-p))
        (if my-fullscreen-p
	      (my-non-fullscreen)
	  (my-fullscreen)))
(global-set-key (kbd "<f11>") 'my-toggle-fullscreen)

;; better scrolling
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
)
