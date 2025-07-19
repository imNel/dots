;; Package Manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; use use-package
(straight-use-package 'use-package)
;; automatically ensure every package exists (like :ensure or :straight)
(setq straight-use-package-by-default t)

;; Emacs Defaults
(use-package emacs
  :custom
  (menu-bar-mode nil)         ;; Disable the menu bar
  (scroll-bar-mode nil)       ;; Disable the scroll bar
  (tool-bar-mode nil)         ;; Disable the tool bar
  (inhibit-startup-screen t)  ;; Disable welcome screen
  (inhibit-startup-message t)
	(inhibit-startup-echo-area-message t)
	(initial-scratch-message nil)

  (delete-selection-mode t)   ;; Select text and delete it by typing.
  (electric-indent-mode nil)  ;; Turn off the weird indenting that Emacs does by default.

  (blink-cursor-mode nil)     ;; Don't blink cursor
  (global-auto-revert-mode t) ;; Automatically reload file and show changes if the file has changed

  ;;(dired-kill-when-opening-new-dired-buffer t) ;; Dired don't create new buffer
  ;;(recentf-mode t) ;; Enable recent file mode

  ;;(global-visual-line-mode t)           ;; Enable truncated lines
  (display-line-numbers-type 'relative) ;; Relative line numbers
  (global-display-line-numbers-mode t)  ;; Display line numbers

  (mouse-wheel-progressive-speed nil) ;; Disable progressive speed when scrolling
  (scroll-conservatively 10) ;; Smooth scrolling
  (scroll-margin 8)

  (tab-width 2)

  (make-backup-files nil) ;; Stop creating ~ backup files
  (auto-save-default nil) ;; Stop creating # auto save files

	(frame-resize-pixelwise t) ; Size the window correctly on macOS
	(frame-title-format nil) ; remove titlebar
  :hook
  (prog-mode . (lambda () (hs-minor-mode t))) ;; Enable folding hide/show globally
  :config
  ;; Move customization variables to a separate file and load it, avoid filling up init.el with unnecessary variables
  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)
  :bind (
         ([escape] . keyboard-escape-quit) ;; Makes Escape quit prompts (Minibuffer Escape)
         ;; Zooming In/Out
         ("C-+" . text-scale-increase)
         ("C--" . text-scale-decrease)
         ("<C-wheel-up>" . text-scale-increase)
         ("<C-wheel-down>" . text-scale-decrease)
         )
  )

;; Evil Mode
(use-package evil
  :init
  (evil-mode)
  :custom
  (evil-want-keybinding nil)    ;; Disable evil bindings in other modes (It's not consistent and not good)
  (evil-want-C-u-scroll t)      ;; Set C-u to scroll up
  (evil-undo-system 'undo-redo) ;; C-r to redo
  (org-return-follows-link t)   ;; Sets RETURN key in org-mode to follow links
	(evil-vsplit-window-right t)
  (evil-split-window-below t)
  ;; Unmap keys in 'evil-maps. If not done, org-return-follows-link will not work
  :bind (:map evil-motion-state-map
              ("SPC" . nil)
              ("RET" . nil)
              ("TAB" . nil)))
(use-package evil-collection
  :after evil
  :config
  ;; Setting where to use evil-collection
  (setq evil-collection-mode-list '(dired ibuffer magit corfu vertico consult info))
  (evil-collection-init))

;; Nano Emacs
(straight-use-package
  '(nano :type git :host github :repo "rougier/nano-emacs"))
;; (require 'nano-layout)
(require 'nano-base-colors)
(require 'nano-faces)
(require 'nano-theme)
(require 'nano-theme-light)
(nano-theme-set-light)
(call-interactively 'nano-refresh-theme)
;; (require 'nano-defaults) ;; TODO check out if theres anything i want from here
(require 'nano-modeline)

(setq org-directory "~/org/")
(use-package org)
(require 'nano-writer)
