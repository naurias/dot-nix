
(setq doom-theme 'doom-tokyo-night)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))



(defun org-doom-gruvbox ()
  "Enable Gruvbox Dark colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.8 "#fb4934" ultra-bold)
         (org-level-2 1.4 "#fabd2f" extra-bold)
         (org-level-3 1.2 "#b8bb26" bold)
         (org-level-4 1.1 "#83a598" semi-bold)
         (org-level-5 1.1 "#d3869b" normal)
         (org-level-6 1.1 "#928374" normal)
         (org-level-7 1.1 "#d79921" normal)
         (org-level-8 1.1 "#8ec07c" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))


(after! ox-latex
  (add-to-list 'org-latex-packages-alist '("" "tokyonight"))
  (add-to-list 'org-latex-classes
               '("tokyonight-article"
                 "\\documentclass[11pt]{article}
\\usepackage{tokyonight}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (setq org-latex-default-class "tokyonight-article"))

;; HTML THEMING (Org export)
(after! org
  (setq org-html-head
        (concat
         "<style type=\"text/css\">\n"
         (with-temp-buffer
           (insert-file-contents (expand-file-name "~/.config/doom/tokyonight.css"))
           (buffer-string))
         "\n</style>")))
