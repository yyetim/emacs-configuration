;; library, auto-save, backup paths
(setq backup-directory-alist (quote ((".*" . "~/.emacs.mine/"))))
(setq tramp-auto-save-directory "~/.emacs.mine/")
(add-to-list 'load-path "~/emacs_configuration/elisp")

;; system-dependent setup and latex
(add-hook 'latex-mode-hook '(lambda ()
			      (load-library "latex-compile-preview")))
(add-hook 'c-mode-common-hook '(lambda ()
				 (column-marker-1 80)
				 (set-fill-column 79)))
(load-library (symbol-name system-type))

;; vim-like include file search, uses local shell and grep
(autoload 'search-this-word-in-headers "include-finder" nil t nil)
(autoload 'add-path "include-finder" nil t nil)

(require 'saveplace)
(setq-default save-place t)

;; setup tabbar if it is available
(when (require 'tabbar nil 'noerror)
    (progn (tabbar-mode t)
	   (defun tabbar-add-tab (tabset object &optional append_ignored)
	     "Add to TABSET a tab with value OBJECT if there isn't one there yet.
 If the tab is added, it is added at the beginning of the tab list,
 unless the optional argument APPEND is non-nil, in which case it is
 added at the end."
	     (let ((tabs (tabbar-tabs tabset)))
	       (if (tabbar-get-tab object tabset)
		   tabs
		 (let ((tab (tabbar-make-tab object tabset)))
		   (tabbar-set-template tabset nil)
		   (set tabset (sort (cons tab tabs)
				     (lambda (a b)
				       (string< (buffer-name (car a))
						(buffer-name (car b))))))))))
	   (setq tabbar-buffer-groups-function
		 (lambda()
		   (let ((dir (expand-file-name (concat default-directory "/.."))))
		     (cond ((member (buffer-name) '("*Completions*"
						    "*scratch*"
						    "*Calendar*"
						    "*Messages*"
						    "*Ediff Registry*"))
			    (list "#misc"))
			   ((string-match-p "/.emacs.d/" dir)
			    (list ".emacs.d"))
			   (t (list dir))))))))

;; misc
(setq ring-bell-function 'ignore)
(add-to-list 'auto-mode-alist '("\\.str$" . c++-mode))
(global-set-key (kbd "RET") 'newline-and-indent)
(add-hook 'dired-mode-hook '(lambda () (local-set-key [mouse-2] 'dired-find-file)))
(autoload 'column-marker-1 "column-marker" "Highlight a column." t)
(setq desktop-files-not-to-save "^$")
(setq c-default-style "linux" c-basic-offset 8)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

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

;; cscope stuff
(if (featurep 'xcscope)
      (setq cscope-do-not-update-database t))

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
