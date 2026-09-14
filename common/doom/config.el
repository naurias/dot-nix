;; extra file
(load! "style")

;; ------------------ FONTS --------------------- ;;

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu Sans" :size 19))

(custom-set-faces!
  '(font-lock-comment-face :slant italic :family "Cascadia Code")
  '(font-lock-keyword-face :slant italic :family "Cascadia Code"))



;; ------------------ GENERAL CONFIGURATIONS --------------------- ;;

;; Frame Opacity / Transparency
(set-frame-parameter nil 'alpha-background 90) ; For current frame
 (add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth

;; Zen Mode
(after! writeroom-mode
  ;; Disable line numbers and relative line numbers in writeroom (Zen) mode
  (add-hook 'writeroom-mode-enable-hook (lambda ()
                                          (setq display-line-numbers nil)))

  ;; Optional: restore line numbers when leaving Zen mode
  (add-hook 'writeroom-mode-disable-hook (lambda ()
                                           (setq display-line-numbers t))))




(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((mermaid . t)
     ;; Add more languages here
     )))



;; quote block configs
(custom-set-faces!
  '(org-quote :extend t :slant italic :family "Cascadia Code")
  )

;; org-roam directories
(setq org-roam-capture-templates
      '(
        ("d" "default" plain "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("n" "Notes" plain "%?"
         :if-new (file+head "Notes/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
         )

        ("c" "CSS")
        ("cd" "default" plain "%?"
         :if-new (file+head "CSS/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

        ("ce" "English" plain "%?"
         :if-new (file+head "CSS/English/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

        ("ci" "Islamic-Studies" plain "%?"
         :if-new (file+head "CSS/Islamic-Studies/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

        ("cc" "Current-Affairs" plain "%?"
         :if-new (file+head "CSS/Current-Affairs/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

;;        ("cg" "GSA" plain "%?"
;;         :if-new (file+head "CSS/GSA/${slug}.org"
;;                            "#+title: ${title}\n")
;;         :immediate-finish t
;;         :jump-to-captured t
;;        )
        ("cg" "GSA")
        ("cgd" "GSA default" plain "%?"
         :if-new (file+head "CSS/GSA/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
         )

        ("cgp" "Physics" plain "%?"
         :if-new (file+head "CSS/GSA/Physics/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
         )

        ("cgm" "GSA default" plain "%?"
         :if-new (file+head "CSS/GSA/Maths/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
         )

        ("cm" "Maths" plain "%?"
         :if-new (file+head "CSS/Maths/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

        ("cp" "Pak-Affairs" plain "%?"
         :if-new (file+head "CSS/Pak-Affairs/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t
        )

        ))



;; Markdown Theming
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.8 weight: ultra-bold :foreground "#458588"))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6 weight: extra-bold :foreground "#b16286"))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4 weight: semi-bold :foreground "#98971a"))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3 weight: bold :foreground "#fb4934"))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2 weight: normal :foreground "#83a598"))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1 weight: normal :foreground "#d3869b")))))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")
(setq org-agenda-files '("~/Documents/org/"))
(setq org-roam-directory "~/Documents/org/roam/")

