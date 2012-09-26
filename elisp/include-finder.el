;; Author: Yavuz Yetim


(defvar find-header-file-header-file-prefixes nil)

(defun log (string)
  (let ((old-buffer (current-buffer)))
    (switch-to-buffer "my-debug-log")
    (insert string)
    (switch-to-buffer old-buffer)))
(defun log-list-rec (string-list)
  (if (null string-list)
      nil
    (log (concat (car string-list) " "))
    (log-list-rec (cdr string-list))))

(defun add-path (path)
  (interactive "sPath: ")
  (add-to-list 'find-header-file-header-file-prefixes (concat path "/"))
  (print find-header-file-header-file-prefixes))

(defun get-remote-prefix ()
  (with-temp-buffer
      (insert-string default-directory)
      (replace-regexp-uninteractive-once "\\(.*:\\)*[^:]*" "\\1")
      (if (string= (buffer-string) "")
	  nil
	(concat (buffer-string) "/"))))

(defun find-header-file-on-path (prefix-list filename)
  (log-list-rec prefix-list)
  (if (null prefix-list)
      (progn
	(log "NULL\n")
	nil)
    (if (file-exists-p (concat (get-remote-prefix) (car prefix-list) filename))
	(progn
	  (log (concat "EXISTS:" (car prefix-list) filename))
	  (concat (car prefix-list) filename))
      (log (concat "DOES NOT EXIST:" (car prefix-list) filename "\n"))
     (find-header-file-on-path (cdr prefix-list) filename))))

(defun replace-regexp-uninteractive (regexp to-string)
  (save-excursion
    (goto-char (point-min))
      (while (re-search-forward regexp nil t)
	(replace-match to-string nil nil))))

(defun replace-regexp-uninteractive-once (regexp to-string)
  (save-excursion
    (goto-char (point-min))
      (if (re-search-forward regexp nil t)
	(replace-match to-string nil nil))))

(defun grep-for-header (file-name)
  (with-temp-buffer
    (process-file "grep" nil t nil "-s" "[[:blank:]]*#[[:blank:]]*include[[:blank:]]*[\"<]*\\([^<>\"]*\\)[\">]*[[:blank:]]*" file-name)
    (replace-regexp-uninteractive "[[:blank:]]*#[[:blank:]]*include[[:blank:]]*[\"<]*\\([^<>\"]*\\)[\">]*[[:blank:]]*" "\\1")
    (split-string (buffer-string) "\n")))

(defun grep-for-string (header-search-string file-name)
  (with-temp-buffer
    (process-file "grep" nil t nil "-nH" "-s" header-search-string (find-header-file-on-path find-header-file-header-file-prefixes file-name))
    (list (buffer-string))))

(defun add-elements-rec (elements lookup-list permanent-list)
  (if (null elements)
      (list lookup-list permanent-list)
    (if (and 
         (null (member (car elements) permanent-list))
         (find-header-file-on-path find-header-file-header-file-prefixes (car elements)))
        (let ((new-permanent-list (cons (car elements) permanent-list)) 
              (new-lookup-list (cons (car elements) lookup-list)))
          (add-elements-rec (cdr elements) new-lookup-list new-permanent-list))
      (add-elements-rec (cdr elements) lookup-list permanent-list))))


(defun get-all-headers-rec (lookup-list permanent-list)
  (if (null lookup-list)
      permanent-list
    (let ((header-file-full-path (find-header-file-on-path find-header-file-header-file-prefixes (car lookup-list))))
      (if (null header-file-full-path)
          (get-all-headers-rec (cdr lookup-list) permanent-list)
        (let ((add-return-list (add-elements-rec (grep-for-header header-file-full-path) (cdr lookup-list) permanent-list)))
          (get-all-headers-rec (car add-return-list) (car (cdr add-return-list))))))))

(defun print-to-results-buffer (the-string)
  (switch-to-buffer "*results*")
  (insert the-string))

(defun list-printer (mylist)
  (if (null mylist)
      nil
    (let ((head (car mylist)))
      (if (string= head "")
          nil
        (let ((temp (print-to-results-buffer head)))
          (list-printer (cdr mylist)))))))

(defun search-string-in-headers-rec (header-list header-search-string)
  (if (null header-list)
      nil
    (list-printer (grep-for-string header-search-string (car header-list)))
    (search-string-in-headers-rec (cdr header-list) header-search-string)))

(defun search-string-in-headers (header-search-string current-file-name)
  (let ((all-headers-rec-list (get-all-headers-rec (list current-file-name) (list current-file-name))))
    (search-string-in-headers-rec all-headers-rec-list header-search-string)))

(defun search-this-word-in-headers (word)
  ;; enable deep recursion
  (setq temp-max-lisp-eval-depth max-lisp-eval-depth)
  (setq temp-max-specpdl-size max-specpdl-size)
  (setq max-lisp-eval-depth 3000)
  (setq max-specpdl-size 3000)

  ;; prompt for search
  (interactive "sSearch in headers: ")

  (if (get-buffer "*results*")
      (kill-buffer "*results*"))
  (let ((search-word-buffer-name (buffer-file-name)))
    (with-temp-buffer
      (insert-string search-word-buffer-name)
      (replace-regexp-uninteractive ".*:" "")
      (setq search-word-file-name (buffer-string))
      (replace-regexp-uninteractive "\\(.*\\)/[^/]*" "\\1")
      (setq search-word-directory-name (buffer-string))
      (kill-region (point-min) (point-max))
      (insert-string search-word-file-name)
      (replace-regexp-uninteractive ".*/\\([^/]*\\)" "\\1")
      (setq search-word-file-name (buffer-string))))
  (add-path search-word-directory-name)
  (search-string-in-headers word search-word-file-name)
  (if (string= (buffer-name) "*results*")
      (grep-mode))

  ;; restore default recursion depth
  (setq temp-max-lisp-eval-depth max-lisp-eval-depth)
  (setq temp-max-specpdl-size max-specpdl-size))


