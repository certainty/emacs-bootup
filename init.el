(require 'cl)
(require 'saveplace)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)


(setq bootup/available-runlevels 3)

(setq bootup/base-dir   (file-name-directory (or (buffer-file-name) load-file-name)))

(setq bootup/profiles-dir   (concat bootup/base-dir "profiles/"))
(setq bootup/vendor-dir     nil)
(setq bootup/active-profile (concat bootup/profiles-dir "active/"))

(add-to-list 'load-path bootup/base-dir)

(add-to-list 'load-path (concat bootup/base-dir "elpa-to-submit"))

(setq package-user-dir  (concat bootup/base-dir "elpa"))

(require 'package)

(add-to-list
 'package-archives
 '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list
 'package-archives
 '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; utilities
(defun bootup/load-if-exists (filename)
 (if (file-exists-p filename)
  (load filename)))

(defun bootup/ensure-installed (packages)
 (dolist (p packages)
   (when (not (package-installed-p p))
     (package-install p))))

;; run the boot sequence
(when (file-exists-p bootup/active-profile)
  (setq bootup/vendor-dir (concat bootup/active-profile "vendor/"))
  (add-to-list 'load-path bootup/vendor-dir)

  (setq custom-file (concat bootup/active-profile "custom.el"))

  ;; load alpha file that does basic initialization
  (bootup/load-if-exists (concat bootup/active-profile "alpha.el"))

  ;; load all runlevels in order in active profile
  (dotimes (number (+ 1 bootup/available-runlevels) nil)
    (let ((current-runlevel (format "%s/runlevel%d" bootup/active-profile number)))
      (when (file-exists-p current-runlevel)
        (dolist (src (directory-files current-runlevel 1 ".*el$"))
    	  (load src)))))

  (bootup/load-if-exists custom-file)

  ;; lastly load omega to finish things up
  (bootup/load-if-exists (concat bootup/active-profile "omega.el")))

(put 'erase-buffer 'disabled nil)
