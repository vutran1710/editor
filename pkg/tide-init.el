(require 'tide)
(require 'web-mode)

(defun my/use-tslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (tslint (and root
                      (expand-file-name "node_modules/tslint/bin/tslint.js"
                                        root))))
    (when (and tslint (file-executable-p tslint))
      (setq-local flycheck-javascript-tslint-executable tslint))))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (yas-reload-all)
  (tide-hl-identifier-mode +1)
  (my/use-tslint-from-node-modules))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
(setq tide-format-options '(
                            :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
                            :placeOpenBraceOnNewLineForFunctions nil
                            :placeOpenBraceOnNewLineForControlBlocks nil
                            :insertSpaceAfterSemicolonInForStatements t
                            :insertSpaceBeforeAndAfterBinaryOperators t
                            :insertSpaceAfterKeywordsInControlFlowStatements t))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)
