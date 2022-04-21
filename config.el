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
       (setq doom-font (font-spec :family "Fira Mono" :size 18 :weight 'semi-light)
             doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15)
             doom-big-font (font-spec :family "Fira Mono" :size 15))
       )
      (t (setq doom-font (font-spec :family "monospace" :size 18 :weight 'semi-light) ;; default clause
               doom-variable-pitch-font (font-spec :family "sans" :size 15)
               doom-big-font (font-spec :family "monospace" :size 15))
         ))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
                                        ; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers t)
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

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
                                        ; (load-theme 'doom-vibrant t)
                                        ; (load-theme 'doom-badger t)
                                        ; (load-theme 'doom-gruvbox t)
                                        ; (load-theme 'doom-nord t)
                                        ; (load-theme 'doom-palenight t)
                                        ; (load-theme 'doom-sourcerer t)
  (load-theme 'doom-tomorrow-night t)
                                        ; (load-theme 'doom-zenburn t)
                                        ; (load-theme 'doom-material t)
                                        ; (load-theme 'doom-material-dark t)
                                        ; (load-theme 'doom-wilmersdorf t)
                                        ; (load-theme 'doom-monokai-spectrum t)
                                        ; (load-theme 'doom-moonlight t)
                                        ; (load-theme 'doom-xcode t)
                                        ; (load-theme 'doom-spacegrey t)
                                        ; (load-theme 'doom-snazzy t)
                                        ; (load-theme 'atom-one-dark t)
                                        ; (load-theme 'moe-dark t)
                                        ; (load-theme 'nano-dark t)
                                        ; (load-theme 'immaterial-dark t)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; Custom config begins
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(pyenv-mode rainbow-delimiters)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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

;; tree sitter mode
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(tree-sitter-hl-add-patterns 'python
  [((string) @constant
    (.match? @constant "^\"\"\""))])

;; ivy
(after! ivy-mode
  (setq posframe-mouse-banish nil)
  )

;; helm
(after! helm-mode
  (setq posframe-mouse-banish nil)
  )

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

;; macos problem
;; home and end key goes to top and bottom of file
;; fix to go to beginning and end of line respectively
(cond (IS-MAC
       (global-set-key (kbd "<home>") 'move-beginning-of-line)
       (global-set-key (kbd "<end>") 'move-end-of-line)))


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
  (centaur-tabs-mode t)
  (centaur-tabs-group-by-projectile-project))

;; dimmer
(dimmer-configure-which-key)
(dimmer-configure-magit)
(dimmer-configure-org)
(dimmer-configure-posframe)
(dimmer-mode 1)
