;;; init.el --- "Ultimate Rice" IDE Config -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. PERFORMANCE TWEAKS
;; =============================================================================
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      read-process-output-max (* 1024 1024))

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 16000000
                  gc-cons-percentage 0.1)))

;; =============================================================================
;; 2. PACKAGE INFRASTRUCTURE
;; =============================================================================
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; =============================================================================
;; 3. NO LITTERING (CLEAN CACHE & CONFIG DIRS)
;; =============================================================================
(use-package no-littering
  :config
  (setq no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory)
        no-littering-var-directory (expand-file-name "var/" user-emacs-directory))
  (require 'no-littering))

;; =============================================================================
;; 4. NERD FONTS SETUP (FIX FOR BROKEN ICONS IN GTK EMACS)
;; =============================================================================
;; Issue: Icons missing or shown as boxes in Emacs GUI.
;; Solution:
;;   1. Run M-x nerd-icons-install-fonts inside Emacs.
;;   2. On Linux, run `fc-cache -fv` in terminal.
;;   3. Uncomment and set appropriate font family if needed.
;;   4. If still broken, run M-x nerd-icons-set-font.
;;
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono"))
;; (setq nerd-icons-font-family "FiraCode Nerd Font Mono") ; alternative

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

;; =============================================================================
;; 5. AESTHETICS & ICONS (THE "RICE")
;; =============================================================================
(setq inhibit-startup-message t
      initial-scratch-message nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)

;; Emoji insertion (Emacs 29+ built-in)
(when (fboundp 'emoji-insert)
  (define-key global-map (kbd "C-x 8 e") 'emoji-insert))

;; Kanagawa Dragon theme (replaces Catppuccin)
(use-package kanagawa-themes
  :config
  (load-theme 'kanagawa-dragon t))

;; Doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-lsp t)
  (doom-modeline-env-version t))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Pulse on navigation
(use-package pulse
  :ensure nil
  :hook (xref-after-jump . (lambda () (pulse-momentary-highlight-one-line (point)))))

;; Dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "GNU Emacs"
        dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-show-shortcuts t
        dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5))
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t))

;; =============================================================================
;; 6. COMPLETION ENGINE (VERTICO + ORDERLESS + MARGINALIA + CONSULT)
;; =============================================================================
(use-package vertico
  :init (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-resize t)
  (vertico-count 15))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-y" . consult-yank-pop)
         ("M-s f" . consult-find)
         ("M-s g" . consult-grep)
         ("M-s l" . consult-locate))
  :custom
  (consult-narrow-key "<")
  (consult-line-numbers-widen t))

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir))
  :config (recentf-mode 1))

;; =============================================================================
;; 7. POPUP COMPLETION (CORFU)
;; =============================================================================
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-quit-at-boundary 'separator)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :config (corfu-terminal-mode +1))

;; =============================================================================
;; 8. IDE FUNCTIONS (EGLOT + TREESITTER + CONSULT-EGLOT)
;; =============================================================================
(use-package eglot
  :ensure nil
  :hook ((python-ts-mode c-ts-mode c++-ts-mode js-ts-mode java-mode) . eglot-ensure)
  :config
  (setq eglot-events-buffer-config '(:size 0 :format full)
        eglot-autoshutdown t
        eglot-connect-timeout 30)
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode c-ts-mode c++-ts-mode) .
                 ("clangd" "--header-insertion=never" "--background-index" "-j=4")))
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(js-mode js-ts-mode . ("typescript-language-server" "--stdio"))))

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config (global-treesit-auto-mode))

(use-package consult-eglot
  :bind (:map eglot-mode-map
              ("M-s l" . consult-eglot-symbols)))

(with-eval-after-load 'eglot
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

;; =============================================================================
;; 9. VERSION CONTROL (MAGIT + VC)
;; =============================================================================
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)
         ("C-c M-g" . magit-file-dispatch))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(keymap-set global-map "C-x v =" #'vc-diff)
(keymap-set global-map "C-x v l" #'vc-print-log)
(keymap-set global-map "C-x v v" #'vc-next-action)
(keymap-set global-map "C-x v d" #'vc-dir)

;; =============================================================================
;; 10. FILE MANAGER (DIRED ENHANCEMENTS)
;; =============================================================================
(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("(" . dired-hide-details-mode)
              ("C-c C-c" . dired-do-async-shell-command)
              ("C-x C-j" . dired-jump)
              ("z" . dired-do-compress-to))
  :config
  (setq dired-listing-switches "-lha --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies 'always
        dired-recursive-deletes 'top)
  (put 'dired-find-alternate-file 'disabled nil))

(use-package dired-preview
  :hook (dired-mode . dired-preview-mode)
  :custom
  (dired-preview-delay 0.5)
  (dired-preview-ignored-extensions-regexp ".\\(pdf\\|docx\\|xlsx\\)$"))

;; =============================================================================
;; 11. ESHELL (EMACS SHELL)
;; =============================================================================
(use-package eshell
  :ensure nil
  :bind (("C-!" . eshell)
         ("C-c !" . eshell-command))
  :hook (eshell-mode . (lambda ()
                         (eshell-aliases)
                         (company-mode -1)))
  :config
  (defun eshell-aliases ()
    (eshell/alias "ff" "find-file $1")
    (eshell/alias "dired" "find-file $1")
    (eshell/alias "z" "cd $1 && ls"))
  (setq eshell-history-size 10000
        eshell-save-history-on-exit t
        eshell-banner-message "")
  (add-hook 'eshell-mode-hook (lambda () (setq show-trailing-whitespace nil))))

;; =============================================================================
;; 12. BUFFER MANAGEMENT (IBUFFER)
;; =============================================================================
(use-package ibuffer
  :bind (("C-x C-b" . ibuffer))
  :config
  (setq ibuffer-saved-filter-groups
        '((default
            ("Dired" (mode . dired-mode))
            ("Eshell" (mode . eshell-mode))
            ("Magit" (name . "^magit"))
            ("Code" (or (mode . prog-mode) (mode . text-mode)
                        (mode . fundamental-mode))))))
  (add-hook 'ibuffer-mode-hook
            (lambda () (ibuffer-switch-to-saved-filter-groups "default"))))

;; =============================================================================
;; 13. HELPFUL (BETTER DOCUMENTATION)
;; =============================================================================
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         :map help-map
         ("F" . helpful-function)))

;; =============================================================================
;; 14. WHICH-KEY (DISCOVER KEYBINDS)
;; =============================================================================
(use-package which-key
  :defer 1
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5
        which-key-popup-type 'side-window
        which-key-side-window-slot -1))

;; =============================================================================
;; 15. GENERAL UTILITIES
;; =============================================================================
(electric-pair-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)

(use-package saveplace
  :ensure nil
  :config (save-place-mode 1))

;; =============================================================================
;; 16. CUSTOM KEYBINDINGS
;; =============================================================================
(defvar-keymap my-code-map
  "r" #'eglot-rename
  "a" #'eglot-code-actions
  "f" #'eglot-format-buffer
  "d" #'xref-find-definitions
  "h" #'eldoc)

(keymap-set global-map "C-c c" my-code-map)
(keymap-set global-map "C-x k" #'kill-current-buffer)

;; =============================================================================
(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(kanagawa-dragon))
 '(custom-safe-themes
   '("d2ab3d4f005a9ad4fb789a8f65606c72f30ce9d281a9e42da55f7f4b9ef5bfc6"
     "daa27dcbe26a280a9425ee90dc7458d85bd540482b93e9fa94d4f43327128077"
     "c20728f5c0cb50972b50c929b004a7496d3f2e2ded387bf870f89da25793bb44"
     default))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
