;; swm-freebsd-cpu-modeline.lisp
;;
;; Put %f in your modeline format string to show the current CPU frequency in MHz.
;; Put %t in your modeline format string to show the current CPU temperature.
;;

(in-package #:swm-freebsd-cpu-modeline)

(defvar *cpu-freq* 0)
(defvar *cpu-prev-time* 0)
(defvar *cpu-temp* 0)

(defun update-cpu-info ()
  (let ((now (/ (get-internal-real-time) internal-time-units-per-second)))
    (when (or (= 0 *cpu-prev-time*) (>= (- now *cpu-prev-time*) 5))
      (setf *cpu-prev-time* now)
      (let ((cpu-info
	     (stumpwm::split-string
	      (stumpwm::run-prog-collect-output "/sbin/sysctl" "-n" "dev.cpu.0.freq" "hw.acpi.thermal.tz0.temperature"))))
	(setf *cpu-freq* (car cpu-info))
	(setf *cpu-temp* (cl-ppcre::regex-replace ".\\d*C" (nth 1 cpu-info) ""))))))

(defun fmt-freebsd-cpu-freq-modeline (ml)
  "Return the current CPU frequency in MHz."
  (declare (ignore ml))
  (update-cpu-info)
  (format nil "~4a" *cpu-freq*))

(defun fmt-freebsd-cpu-temp-modeline (ml)
  "Return the current CPU temp in degrees Celsius."
  (declare (ignore ml))
  (update-cpu-info)
  (format nil "~a" *cpu-temp*))
  
;; Install formatters
(stumpwm::add-screen-mode-line-formatter #\f #'fmt-freebsd-cpu-freq-modeline)
(stumpwm::add-screen-mode-line-formatter #\t #'fmt-freebsd-cpu-temp-modeline)
