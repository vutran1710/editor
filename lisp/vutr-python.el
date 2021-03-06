;;; package --- Summary:
;;; Commentary:
;;; python setup
;;; Code:

;; Custom tweaks
(defun setup-checkers (python-bin-path)
  "Setup checkers path depends on the location of virtualenv dir."
  (require 'flycheck)
  (setq flycheck-python-flake8-executable python-bin-path)
  (setq flycheck-python-pylint-executable python-bin-path)
  (flycheck-add-next-checker 'python-flake8 'python-pylint)
  (flycheck-add-next-checker 'python-pylint 'python-mypy))

(defun find-venv-dir-and-setup-checkers ()
  "Look for .venv dir.  If exists, setup flycheck-checkers."
  (require 'projectile)
  (let ((venv-path (concat (projectile-project-root) ".venv")))
    (if (f-exists? venv-path)
        (progn
          (setup-checkers (concat venv-path "/bin/python3"))))))


;; Install stuffs
(use-package poetry
  :ensure t
  :config
  (poetry-tracking-mode nil))

(use-package pyvenv
  :ensure t
  :diminish
  :hook
  (python-mode . (lambda()
                   (blacken-mode)
                   (find-venv-dir-and-setup-checkers)))
  :config
  (pyvenv-mode +1)
  (pyvenv-tracking-mode +1))

(use-package blacken
  :ensure t)

(use-package lsp-python-ms
  :ensure t
  :init
  (setq lsp-python-ms-auto-install-server t)
  (setq lsp-diagnostics-provider :none)
  (add-to-list 'auto-mode-alist '("\\Pipfile\\'" . conf-unix-mode))
  :hook
  (python-mode . (lambda ()
                   (require 'lsp-python-ms)
                   (lsp-deferred))))


(provide 'vutr-python)
;;; vutr-python ends here
