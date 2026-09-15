
;; extra file
(load! "style")
(load! "styx")

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

;; org-roam dynamic capture — one template; folders auto-created on demand.
(defvar styx/roam--last-dir "Notes"
  "Last used roam subdirectory, offered as default at capture.")

(defun styx/roam--subdirs ()
  "Relative subdirectories of `org-roam-directory' for completion."
  (let ((root (expand-file-name org-roam-directory)))
    (when (file-directory-p root)
      (mapcar (lambda (d) (file-relative-name d root))
              (seq-remove (lambda (d) (string-match-p "/\\." d))
                          (seq-filter #'file-directory-p
                                      (directory-files-recursively
                                       root "" t)))))))

(defun styx/roam-target ()
  "Return capture file \"DIR/<slug>.org\", prompting for DIR once.
New (nested) directories are created automatically."
  (let ((dir (or (plist-get org-roam-capture--info :styx-dir)
                 (let ((choice (completing-read
                                (format "Roam folder (default %s): "
                                        styx/roam--last-dir)
                                (styx/roam--subdirs)
                                nil nil nil nil styx/roam--last-dir)))
                   (when (string-empty-p choice)
                     (setq choice styx/roam--last-dir))
                   (setq styx/roam--last-dir choice)
                   (setq org-roam-capture--info
                         (plist-put org-roam-capture--info :styx-dir choice))
                   choice))))
    (make-directory (expand-file-name dir org-roam-directory) t)
    (concat (file-name-as-directory dir)
            (org-roam-node-slug org-roam-capture--node)
            ".org")))

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("r" "roam" plain "%?"
         :if-new (file+head styx/roam-target
                            "#+title: ${title}\n")
         :immediate-finish t
         :jump-to-captured t)))



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

