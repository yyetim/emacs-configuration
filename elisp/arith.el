;; binary, hex, decimal stuff

(defun binary-rec (dec-num mlist)
  (if (= 0 dec-num)
      mlist
    (if (= (% dec-num 2) 1) 
        (binary-rec (/ dec-num 2) (cons ?1 mlist))
      (binary-rec (/ dec-num 2) (cons ?0 mlist))
      )))

(defun binary-str (dec-str)
  (concat (binary-rec (string-to-number dec-str) nil)))

(defun get-hex-str (dec-str)
  (format "%x" (string-to-number dec-str)))

(defun hex ()
  (interactive)
  (save-excursion
    (let ((old-point (point)))
      (let
          ((reg-search (search-forward-regexp "[a-fA-F0-9]+")))
        (let
            ((new-point (point)))
          (let ((the-str (filter-buffer-substring old-point new-point)))
            (let ((dec-str (number-to-string (read (concat "#x" the-str)))))
              (princ (concat "bin: " (binary-str dec-str) "\ndec: " dec-str "\nhex: " (get-hex-str dec-str))))))))))

(defun bin ()
  (interactive)
  (save-excursion
    (let ((old-point (point)))
      (let
          ((reg-search (search-forward-regexp "[a-fA-F0-9]+")))
        (let
            ((new-point (point)))
          (let ((the-str (filter-buffer-substring old-point new-point)))
            (let ((dec-str (number-to-string (read (concat "#b" the-str)))))
              (princ (concat "bin: " (binary-str dec-str) "\ndec: " dec-str "\nhex: " (get-hex-str dec-str))))))))))
