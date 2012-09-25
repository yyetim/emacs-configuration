
(defun llvm-dis (filename)
  (interactive "fFind file: ")
  (switch-to-buffer (generate-new-buffer-name (file-name-nondirectory filename)))
  (call-process-shell-command (concat "llvm-dis < " filename) nil t)
)
