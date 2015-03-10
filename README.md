# `swm-freebsd-cpu-modeline`

Put %f and %t in your StumpWM mode-line format string (*screen-mode-line-format*) to
show the frequency and temperature of your CPU.

In addition to the lisp code, there is a small Bourne shell script, ml_cpu.sh.
Make sure this script is executable by the user running StumpWM and within the
user's $PATH.  Have a look at the script to customize certain settings, such as
the interval between updates.  At the top of the script there is a variable,
cpu_cmd, that holds a sysctl command.  You may need to tweek this command, so
that it returns your CPU's frequency and temperature.

FAQ

Q: What do I need to put in my ~/.stumpwmrc to get this working?

A: First, make sure the source is in your load-path.  To add it, use something
like
```lisp
    (add-to-load-path "/usr/home/jrm/scm/swm-freebsd-cpu-modeline")
```
Next, load the module with
```lisp
    (load-module "swm-freebsd-cpu-modeline")
```
Finally create a mode-line format string with %f and %t in it, e.g.,
```lisp
    (setf *screen-mode-line-format* "^[^8*CPU: ^] %f^[^9*MHz^] %t^[^9*°C^]")
```

Q: So, why use a separate script?  Couldn't all the code be contained within the
module?

A: Yes, it could.  I tried doing that with and without threads.  I found StumpWM
became less responsive in both cases.  Don't you prefer a snappy StumpWM?

Q: Will this only run on FreeBSD?

A: By default, yes, but it should be quite simple to modify ml_cpu.sh to get it
working on your OS.