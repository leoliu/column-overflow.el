;;; column-overflow.el --- column overflow mode      -*- lexical-binding: t; -*-

;; Copyright (C) 2013-2014  Leo Liu

;; Author: Leo Liu <sdl.web@gmail.com>
;; Keywords: extensions, lisp
;; Created: 2013-12-25

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A minor mode to indicate column overflow.

;;; Code:

(defgroup column-overflow nil
  "Indicate column overflow."
  :group 'editing)

(defcustom column-overflow-width 80
  "The column overflow width."
  :safe 'integerp
  :type '(choice function integer)
  :group 'column-overflow)

(defface column-overflow '((t (:inverse-video t :inherit warning)))
  "Face used to indicate column overflow."
  :group 'column-overflow)

(defun column-overflow-width ()
  (if (functionp column-overflow-width)
      (funcall column-overflow-width)
    column-overflow-width))

(defconst column-overflow-keywords
  `((,(lambda (limit)
        (let ((col (column-overflow-width)))
          (while (< (point) limit)
            (end-of-line)
            (when (> (current-column) col)
              (move-to-column (1+ col))
              (when (looking-at ".")
                (font-lock-apply-highlight '(0 'column-overflow t))))
            (forward-line 1)))
        nil))))

;;;###autoload
(define-minor-mode column-overflow-mode nil
  :lighter ""
  (unless (minibufferp)
    (if column-overflow-mode
        (font-lock-add-keywords nil column-overflow-keywords t)
      (font-lock-remove-keywords nil column-overflow-keywords))
    (jit-lock-refontify)))

(provide 'column-overflow)
;;; column-overflow.el ends here
