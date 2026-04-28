;;; init.el --- The "Ultimate Rice" IDE Config -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. PERFORMANCE OVERDRIVE
;; =============================================================================
(setq gc-cons-threshold 100000000) ; 100MB during startup
(setq read-process-output-max (* 1024 1024)) ; 1MB chunks for LSP
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 16000000)))

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
;; 3. THE "RICE" (Aesthetics & Icons)
;; =============================================================================
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(set-fringe-mode 10) ; Give the code some breathing room

;; Icons (Required for the "Rice" feel)
(use-package nerd-icons)

(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin :no-confirm))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-lsp t)
  (doom-modeline-env-version t))

;; Visual feedback on long jumps
(use-package pulse
  :ensure nil
  :hook (xref-after-jump . (lambda () (pulse-momentary-highlight-one-line (point)))))

;; Rainbow delimiters for that sweet color-coded parenthesis logic
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  
  ;; Customization
  (setq dashboard-banner-logo-title "GNU Emacs")
  (setq dashboard-startup-banner 'logo) ; Can be 'official, 'logo, or a path to a .txt for ASCII
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)))
  
  ;; Use nerd-icons in the dashboard
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  ;; Customize the footer
  (setq dashboard-set-footer nil)
  
  ;; Initial message
  (setq dashboard-init-info "Welcome to the Emacs Operating System"))

;; =============================================================================
;; 4. THE ENGINE (Vertico + Orderless + Consult)
;; =============================================================================
(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles . (partial-completion))))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-y" . consult-yank-pop)))

;; =============================================================================
;; 5. MODERN COMPLETION (Corfu + Nerd Icons)
;; =============================================================================
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-quit-at-boundary 'separator)
  :init
  (global-corfu-mode))

;; Add icons to the completion popup
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :ensure t
  :config (corfu-terminal-mode +1))

(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; =============================================================================
;; 6. THE IDE (Eglot + Tree-sitter + Consult-Eglot)
;; =============================================================================
(use-package eglot
  :ensure nil
  :hook ((python-ts-mode c-ts-mode c++-ts-mode js-ts-mode java-mode) . eglot-ensure)
  :config
  (setq eglot-events-buffer-config '(:size 0 :format full)) ; Performance fix
  (setq eglot-autoshutdown t) ; Kill server when last buffer is closed
  
  ;; Customizing specific servers
  (add-to-list 'eglot-server-programs
               `((c-mode c++-mode c-ts-mode c++-ts-mode) . 
                 ("clangd" "--header-insertion=never" "--background-index" "-j=4"))))

;; Modern syntax highlighting (Requires Emacs 29+)
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

;; Search through LSP symbols with Consult UI
(use-package consult-eglot
  :bind (:map eglot-mode-map ("M-s l" . consult-eglot-symbols)))

(with-eval-after-load 'eglot
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

;; =============================================================================
;; 7. PRODUCTIVITY & UTILS
;; =============================================================================
(use-package magit)
(use-package which-key :init (which-key-mode))
(use-package no-littering)

(electric-pair-mode 1)
(savehist-mode 1) ; Remember minibuffer history
(recentf-mode 1)  ; Remember recent files

;; =============================================================================
;; 8. KEYBINDINGS (The "Quick Action" Layer)
;; =============================================================================
(defvar-keymap my-code-map
  :doc "My custom code actions map"
  "r" #'eglot-rename
  "a" #'eglot-code-actions
  "f" #'eglot-format-buffer
  "d" #'xref-find-definitions
  "h" #'eldoc)

(keymap-set global-map "C-c c" my-code-map)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
