;;; init.el --- "Ultimate Rice" IDE Config -*- lexical-binding: t; -*-

;; =============================================================================
;; 1. PERFORMANCE TWEAKS
;; =============================================================================
(setq gc-cons-threshold (* 50 1024 1024)
      read-process-output-max (* 1024 1024)
      create-lockfiles nil) ;; Menos lixo no sistema de arquivos

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

;; Performance package (Doom style)
(use-package gcmh
  :config (gcmh-mode 1))

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

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)

;; =============================================================================
;; 5. THEME & UI ELEMENTS
;; =============================================================================
;; Emoji insertion (Emacs 29+ built-in)
(when (fboundp 'emoji-insert)
  (define-key global-map (kbd "C-x 8 e") 'emoji-insert))

;; Doom Themes (replaces kanagawa-themes)
(use-package doom-themes
  :ensure t
  :config
  ;; Global theme settings
  (setq doom-themes-enable-bold t    ; Enable bold in themes
        doom-themes-enable-italic t) ; Enable italics

  ;; Enhance org-mode fontification (if you use org-mode)
  (doom-themes-org-config)

  ;; Optional: flash the mode-line instead of a sound bell
  ;; (doom-themes-visual-bell-config)
  )

;; Doom modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-lsp t)
  (doom-modeline-env-version t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package pulse
  :ensure nil
  :hook (xref-after-jump . (lambda () (pulse-momentary-highlight-one-line (point)))))

(use-package dashboard
  :if (display-graphic-p)
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-banner-logo-title "GNU Emacs"
        dashboard-startup-banner 'logo
        dashboard-image-banner-max-height 200
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-projects-backend 'projectile
        dashboard-set-init-info t
        dashboard-set-footer nil
        dashboard-items '((recents . 5)
                          (projects . 5))
        dashboard-set-file-icons t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t))

;; =============================================================================
;; 6. COMPLETION ENGINE (THE MODERN STACK)
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
  :defer t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)
         ("M-y" . consult-yank-pop)
         ("M-s f" . consult-find)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line))
  :custom
  (consult-narrow-key "<")
  (consult-line-numbers-widen t))

(use-package embark
  :bind (("C-." . embark-act)         ; "The Magic Button" - ações de contexto
         ("M-." . embark-dwim)        ; Ação inteligente baseada no cursor
         ("C-h B" . embark-bindings)) ; Ver todos os atalhos possíveis aqui
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult-dir
  :after vertico
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir))
  :config (recentf-mode 1))

;; =============================================================================
;; 7. CODE COMPLETION (CORFU)
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
;; 8. IDE (EGLOT)
;; =============================================================================
(use-package eglot
  :ensure nil
  :hook ((c-mode c++-mode python-mode js-mode java-mode lua-mode) . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename)
              ("C-c a" . eglot-code-actions))
  :config
  (setq eglot-events-buffer-config '(:size 0 :format full)
        eglot-autoshutdown t
        eglot-connect-timeout 60)
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode) .
                 ("clangd" "--header-insertion=never" "--background-index" "-j=4")))
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(js-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(lua-mode . ("lua-language-server"))))


(use-package lua-mode
  :ensure t
  :mode ("\\.lua\\'" . lua-mode))

(use-package consult-eglot
  :after eglot
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
  :init
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
  :init
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
  :config
  (defun my-eshell-setup ()
    "Configurações personalizadas para o ambiente Eshell."
    (eshell/alias "ff" "find-file $1")
    (eshell/alias "dired" "find-file $1")
    (eshell/alias "z" "cd $1 && ls")
    (setq show-trailing-whitespace nil))

  (add-hook 'eshell-mode-hook #'my-eshell-setup)

  (setq eshell-history-size 10000
        eshell-save-history-on-exit t
        eshell-banner-message ""))

;; =============================================================================
;; 13. BUFFER MANAGEMENT (IBUFFER)
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
  :init (which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-slot -1))

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
;; 16. NAVIGATION & SELECTION (DOOM STYLE QoL)
;; =============================================================================
(use-package avy
  :bind ("M-j" . avy-goto-char-timer) ; Pule para qualquer lugar da tela com 2 letras
  :custom (avy-timeout-seconds 0.3))

(use-package expand-region
  :bind ("C-=" . er/expand-region))   ; Seleção semântica (expande o range)

;; Better Undo (similar ao comportamento do Doom)
(use-package undo-fu
  :bind (("C-z" . undo-fu-only-undo)
         ("C-S-z" . undo-fu-only-redo)))

;; =============================================================================
;; 17. PROJECT MANAGEMENT (PROJECTILE)
;; =============================================================================
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap ("C-c p" . projectile-command-map)
  :init
  (setq projectile-project-search-path '("~/Projects" "~/src") ; Ajuste seus caminhos
        projectile-switch-project-action #'projectile-dired))

(use-package consult-projectile
  :after (consult projectile)
  :bind (:map projectile-command-map
              ("p" . consult-projectile)))

;; =============================================================================
;; 18. VISUAL FEEDBACK & OVERLAYS
;; =============================================================================
;; Git gutter (mostra alterações na margem esquerda)
(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

;; Highlight TODO/FIXME/NOTE
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO"  . "#FF0000") ("FIXME" . "#FF0000") ("NOTE"  . "#00FF00"))))

;; =============================================================================
;; 19. CUSTOM KEYBINDINGS
;; =============================================================================
(keymap-set global-map "C-x k" #'kill-current-buffer)
(keymap-set global-map "M-/" #'comment-line) ;; Atalho rápido para comentar

;; Ergonomia: Use "ESC" como C-g (Estilo Doom/Vim mas em bindings normais)
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; =============================================================================
;; 20. CUSTOM FILE (LOAD LAST TO PRESERVE USER OVERRIDES)
;; =============================================================================
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; =============================================================================
(provide 'init)
;;; init.el ends here
