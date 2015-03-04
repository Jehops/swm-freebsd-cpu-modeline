;;;; swm-freebsd-cpu-modeline.asd

(asdf:defsystem #:swm-freebsd-cpu-modeline
  :description "Show a FreeBSD host's CPU information in the StumpWM modeline"
  :author "Joseph Mingrone <jrm@ftfl.ca>"
  :license "2-CLAUSE BSD (see COPYRIGHT file for details)"
  :depends-on (#:stumpwm)
  :serial t
  :components ((:file "package")
               (:file "swm-freebsd-cpu-modeline")))

