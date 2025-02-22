;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sugat Bajracharya"
      user-mail-address "sugatbajracharya49@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(cond (IS-MAC ;; set specific font for mac
       (setq doom-font (font-spec :family "Fira Mono" :size 16 :weight 'semi-light)
             doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14)
             doom-big-font (font-spec :family "Fira Mono" :size 14))
       )
      (t (setq doom-font (font-spec :family "DejaVu Sans Mono" :size 18 :weight 'semi-light) ;; default clause
               doom-variable-pitch-font (font-spec :family "DejaVu Sans Mono" :size 15)
               doom-big-font (font-spec :family "DejaVu Sans Mono" :size 15))
         ))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
                                        ; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
;; disable line number in treemacs
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
(add-hook 'dired-mode-hook (lambda() (display-line-numbers-mode -1)))
;; Adds new line to the end of file
(setq mode-require-final-newline t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
                                        ; (load-theme 'doom-one t)
                                        ; (load-theme 'doom-vibrant t)
(load-theme 'doom-tomorrow-night t)
                                        ; (load-theme 'doom-zenburn t)
                                        ; (load-theme 'atom-one-dark t)

;; or for treemacs users
(setq doom-themes-treemacs-theme "nerd-icons")
(doom-themes-treemacs-config)
(doom-themes-visual-bell-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; Custom config begins
(custom-set-variables
 '(package-selected-packages '(pyenv-mode rainbow-delimiters))
 '(flycheck-checker-error-threshold 5000))

(custom-set-faces
 '(font-lock-variable-name-face ((t (:foreground "#CD5C5C"))))
 '(tree-sitter-hl-face:property ((t (:inherit font-lock-constant-face :slant normal))))
 '(tree-sitter-hl-face:comment ((t (:inherit font-lock-comment-face :slant italic))))
 '(tree-sitter-hl-face:doc ((t (:inherit font-lock-doc-face :slant italic))))
 )

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; sort the codes visually selected by length of code.
(defun sort-lines-by-length (reverse beg end)
  "Sort lines by length."
  (interactive "P\nr")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line` and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr reverse 'forward-line 'end-of-line nil nil
                   (lambda (l1 l2)
                     (apply #'< (mapcar (lambda (range) (- (cdr range) (car range)))
                                        (list l1 l2)))))))))
(global-set-key (kbd "C-c L") 'sort-lines-by-length)

;; ORG ROAM UI
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))


(after! (:and treemacs ace-window)
  (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))
(put 'customize-face 'disabled nil)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(put 'upcase-region 'disabled nil)

;; save files and stuft
(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      scroll-margin 2)                            ; It's nice to maintain a little margin

;; ORG MODE
(after! org
  ;; ORG
  (setq org-directory "~/Documents/emacs/org")
  ;; ORG Agenda
  (setq org-agenda-files '("~/Documents/emacs/org-agenda.org"))
  ;; ORG Roamv2
  (setq org-roam-directory "~/Documents/emacs/org-roam2/")
  (setq org-roam-db-location (concat org-roam-directory "org-roam.db"))
  (setq org-roam-completion-everywhere t)
  ;; ORG log
  (setq org-log-done 'time)
  )

;; protobuf mode
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))

(tree-sitter-hl-add-patterns 'python
  [((string) @constant
    (.match? @constant "^\"\"\""))])

;; ivy
(after! ivy-mode
  (setq posframe-mouse-banish nil)
  )
(after! ivy-posframe
  (setq ivy-posframe-display-functions-alist
        '((t . ivy-posframe-display-at-frame-top-center))))

;; ORG ROAM optimizations
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))
(map! :leader
      :desc "Insert node immediately"
      "n r o" #'org-roam-node-insert-immediate)

;; editor config mode
(editorconfig-mode 1)

;; activate windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; home and end key goes to top and bottom of file
;; fix to go to beginning and end of line respectively
;; For normal mode
(define-key evil-motion-state-map (kbd "<home>") 'back-to-indentation)
(define-key evil-motion-state-map (kbd "<end>") 'end-of-line)
;; For insert mode
(global-set-key (kbd "<home>") 'doom/backward-to-bol-or-indent)
(global-set-key (kbd "<end>") 'end-of-line)
;; for emulating ctrl + home and ctrl + end in macOS
(cond (IS-MAC
       (global-set-key (kbd "s-<up>") #'beginning-of-buffer)
       (global-set-key (kbd "s-<down>") #'end-of-buffer)
       ))

;; beacon; cursor flashing
(beacon-mode 1)

;; centaur tabs
(after! centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-bar 'over
        centaur-tabs-height 32
        centaur-tabs-set-icons 0
        centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-headline-match)
  (centaur-tabs-mode t))

;; dimmer
(dimmer-configure-which-key)
(dimmer-configure-magit)
(dimmer-configure-org)
(dimmer-configure-posframe)
(dimmer-mode 1)

;; treemacs
(after! treemacs
  (treemacs-display-current-project-exclusively)
  (treemacs))

;; deadgrep
(map! :leader
      :desc "Deadgrep search"
      "\\" #'deadgrep)

;; lsp
;; there was an issue in my mac which led to having
;; issues with LSP and treemacs so, until fix is found
;; stopping file watching in MAC
(cond (IS-MAC
       (setq lsp-enable-file-watchers nil)
       ))

;; disables the minibuffer popup of object signatures
(setq lsp-signature-auto-activate nil)

(global-set-key (kbd "C-,") 'cheat-sh-search)

;; blamer
(use-package! blamer
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#5c5c5c"
                   :background unspecified
                   :height 140
                   :italic t))))
(map! :leader
      :desc "Toggle Blamer" "i b" #'blamer-mode)

;; breadcrumbs
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-headerline-breadcrumb-segments '(symbols))
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)

;; disable evil's <s> and <f> and overrwrite with avy functions
(after! evil
  (map! :n "s" 'evil-avy-goto-char)
  (map! :n "f" 'evil-avy-goto-char-2))

;; remove git branch from modeline
(advice-add #'doom-modeline-update-vcs-text :override #'ignore)

;; disable semgrep lsp as it causes emacs to freeze in large projects
(after! lsp-mode
  (setq lsp-disabled-clients '(semgrep-ls))
  )
