;; A simple format function,  inspired by gofmt
;;
;; By Yifan Gu, Feb. 8, 2014
;; All copyright reserved
;;
;; Have fun!

;; Finish:
;; on blank lines:
;; elimate white spaces on blank line [done]
;; elimate duplicate blank lines [done]
;;
;; on white space:
;; one and only one white space after comma, colon, and no spaces before them [done]
;; one and only one white space before/after =, <, >
;; no white spaces around ->
;; no white spaces around dot.
;; elimate duplicate white spaces [done]

;; TODO:
;; one and only one white space before/after operators
;; white spaces around * when it's a pointer
;; white spaces around {}
;; white spaces around operators within () and []

(defun in-text (point)
  "return t if point is in a text"
  (if (not (eq (nth 1 (text-properties-at (point))) font-lock-string-face))
      (if (not (eq (nth 1 (text-properties-at (point))) font-lock-comment-face))
          (if (not (eq (nth 1 (text-properties-at (point))) font-lock-doc-face))
              nil
            t))))

(defun replace-regexp-not-in-text (regexp string)
  "replace all regexps that are not in: quotes, doc, comments, to the target string"
  (goto-char (point-min))

  ;; TODO: igore eof, throw other errors
  (ignore-errors
    (while (search-forward-regexp regexp)
      (if (not (in-text (- (point) 1)))
          (progn
            (setq end (point))
            (search-backward-regexp regexp)
            (setq start (point))
            (replace-regexp regexp string nil start end))))))

(defun tfont()
  (interactive)
  (setq h (in-text (point)))
  (if h
      (message "t")
    (message "f")))
;;(message "%d" h))

(defun test()
  (interactive)
  (message "%d" (point)))

(defun fmt ()
  "format the text"
  (interactive)
  (beginning-of-line)
  (set 'origin (point))

  ;; test
  (replace-regexp-not-in-text "ddsdd " "ddsdd")
  
  ;; delete white spaces in blank lines
  (replace-regexp-not-in-text "[\s]+\n" "\n")

  (replace-regexp-not-in-text "bbsdd " "ddsdd")

  ;; delete duplicate blank lines
  (replace-regexp-not-in-text "\n\n[\n]+" "\n\n")

  ;;;; allow only one space after a comma, and no spaces before it
  ;;(replace-regexp-not-in-text "[\s]+," ", ")
  ;;;; allow only one space after a colon, and no spaces before it
  ;;(replace-regexp-not-in-text "[\s]+;" "; ")
  ;;
  ;;;; allow only one space after a dot, and no spaces before it
  ;;(replace-regexp-not-in-text "[\s]+." ". ")
  ;;
  ;;;; allow only one space before/after '='
  ;;(replace-regexp-not-in-text "=" " = ")
  ;;
  ;;;; no spaces around dot
  ;;(replace-regexp-not-in-text "[\s]+.[\s]+" ".")
  ;;;; no spaces around arrow (->)
  ;;(replace-regexp-not-in-text "[\s]+->[\s]+" "->")
  ;;
  ;;;; elimate duplicate white spaces
  ;;(replace-regexp-not-in-text "[\s]+" " ")

  
  ;; indent
  (indent-region (point-min) (point-max) nil)

  ;; delete tailing blank lines
  (goto-char (point-max))
  (set 'movement (skip-chars-backward "\n\r\t"))
  (if (not (equal movement -1))
      (progn
        (delete-region (point) (point-max))
        (insert "\n")))

  ;; move back
  (goto-char origin)
  (beginning-of-line)
  (message "formatting done"))

(provide 'yformat)
