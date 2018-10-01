;; Installed most usable themes & fonts
(mapc
 (lambda (package)
   (unless (package-installed-p package)
     (progn (message "installing %s" package)
            (package-refresh-contents)
            (package-install package))))
 '(tango-plus-theme
   darktooth-theme
   twilight-theme
   greymatters-theme
   hemisu-theme
   tao-theme
   doom-themes
   subatomic-theme))

(provide 'themes-init)
;;; themes-init.el ends here
