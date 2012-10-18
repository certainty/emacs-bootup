(require 'cl)
(require 'saveplace)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

(setq certainty/available-runlevels 3)

(setq certainty/base-dir (file-name-directory (or (buffer-file-name) load-file-name)))
(setq certainty/root-dir (concat certainty/base-dir "root/"))
(setq certainty/vendor-dir (concat certainty/base-dir "vendor/"))
(setq certainty/active-profile (concat certainty/root-dir "active-profile"))

(setq load-path (append load-path (list certainty/base-dir certainty/vendor-dir)))

;; initialize elpa as this is something we rely on
(add-to-list 'load-path (concat certainty/base-dir "elpa-to-submit"))
(setq package-user-dir  (concat certainty/base-dir "elpa"))
(require 'package)
(add-to-list
 'package-archives
 '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


;; utilities
(defun load-if-exists (filename)
 (if (file-exists-p filename)
  (load filename)))

;; run the boot sequence
(when (file-exists-p certainty/active-profile)

  ;; load alpha file that does basic initialization
  (load-if-exists (concat certainty/active-profile "alpha.el"))

  ;; load all runlevels in order in active profile
  (dotimes (number (+ 1 certainty/available-runlevels) nil)
    (let ((current-runlevel (format "%s/runlevel%d" certainty/active-profile number)))
      (when (file-exists-p current-runlevel)
        (dolist (src (directory-files current-runlevel 1 ".*el$"))
    	  (load src)))))

  ;; lastly load omega to finish things up
  (load-if-exists (concat certainty/active-profile "omega.el")))
