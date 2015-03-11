;; swm-freebsd-cpu-modeline.lisp
;;
;; Put %f in your modeline format string to show the current CPU frequency in MHz.
;; Put %t in your modeline format string to show the current CPU temperature.
;;

(in-package #:swm-freebsd-cpu-modeline)

(defvar *cpu-freq* "0")
(defvar *cpu-stream* nil)
(defvar *cpu-temp* 0)

(defun set-cpu-stream ()
  (setf *cpu-stream*
	(sb-ext:process-output
	 (sb-ext:run-program "ml_cpu.sh" nil
			     :output :stream
			     :search t
			     :wait nil))))
  
(defun fmt-freebsd-cpu-freq-modeline (ml)
  "Return the current CPU frequency in MHz."
  (declare (ignore ml))
  (when (not *cpu-stream*)
    (set-cpu-stream))
  (when (listen *cpu-stream*)
    (let ((cpu-info (stumpwm::split-string
		     (read-line *cpu-stream* nil "") " ")))
      (setf *cpu-freq* (car cpu-info))
      (when (equal "" *cpu-freq*) (setf *cpu-freq* "-0.0"))
      (setf *cpu-temp* (cl-ppcre::regex-replace-all ".\\d*C" (nth 1 cpu-info) ""))))
  (format nil "~4d" (read-from-string *cpu-freq*)))

(defun fmt-freebsd-cpu-temp-modeline (ml)
  "Return the current CPU temp in degrees Celsius."
  (declare (ignore ml))
  (format nil "~a" *cpu-temp*))
  
;; Install formatters
(stumpwm::add-screen-mode-line-formatter #\f #'fmt-freebsd-cpu-freq-modeline)
(stumpwm::add-screen-mode-line-formatter #\t #'fmt-freebsd-cpu-temp-modeline)
