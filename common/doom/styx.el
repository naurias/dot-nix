;;; styx.el --- Personal callout blocks -*- lexical-binding: t; -*-
(require 'cl-lib)
(add-to-list 'load-path "~/Artem/Dev/oml")
(require 'oml)

;;; Personal callout blocks: #+begin_note etc. rendered as tinted blocks.
;;; Muted colors that follow the active Doom theme.
;;; Only this file needs to be writable.
;;; You must ensure it is loaded, e.g. add (load! "styx") to config.el.

;; ---------------------------------------------------------------------------
;; 1. Faces — placeholders; real colors are set by
;;    `styx/org-callout--refresh' to follow the active theme.
;;    Body uses :extend t so the tint spans the full width.
;; ---------------------------------------------------------------------------

(defgroup styx/callouts nil
  "Tinted callout special blocks in Org."
  :group 'org)

(defcustom styx/org-callout-blend 0.10
  "How strongly callout backgrounds tint toward their accent color.
0.0 = plain background, 1.0 = full accent.  Mirrors how your Doom
themes style `org-block' with a subtle `(doom-blend yellow bg 0.04)'."
  :type 'number :group 'styx/callouts)

;; Muted fallbacks comparable to the palettes in themes/ (rose-pine iris,
;; foam, gold, love) when neither doom-themes nor the fallback faces help.
(defvar styx/org-callout--fallback-accents
  '(("note" . "#c4a7e7")
    ("tip" . "#9ccfd8")
    ("warning" . "#f6c177")
    ("important" . "#eb6f92")
    ("caution" . "#eb6f92"))
  "Muted fallback accent per callout type.")

(defface styx/org-callout-note-body
  '((t :inherit org-block :extend t))
  "Body of #+begin_note blocks.")
(defface styx/org-callout-note-delimiter
  '((t :inherit org-block-begin-line :weight bold :extend t))
  "Delimiter lines of #+begin_note blocks.")
(defface styx/org-callout-tip-body
  '((t :inherit org-block :extend t))
  "Body of #+begin_tip blocks.")
(defface styx/org-callout-tip-delimiter
  '((t :inherit org-block-begin-line :weight bold :extend t))
  "Delimiter lines of #+begin_tip blocks.")
(defface styx/org-callout-warning-body
  '((t :inherit org-block :extend t))
  "Body of #+begin_warning blocks.")
(defface styx/org-callout-warning-delimiter
  '((t :inherit org-block-begin-line :weight bold :extend t))
  "Delimiter lines of #+begin_warning blocks.")
(defface styx/org-callout-important-body
  '((t :inherit org-block :extend t))
  "Body of #+begin_important blocks.")
(defface styx/org-callout-important-delimiter
  '((t :inherit org-block-begin-line :weight bold :extend t))
  "Delimiter lines of #+begin_important blocks.")
(defface styx/org-callout-caution-body
  '((t :inherit org-block :extend t))
  "Body of #+begin_caution blocks.")
(defface styx/org-callout-caution-delimiter
  '((t :inherit org-block-begin-line :weight bold :extend t))
  "Delimiter lines of #+begin_caution blocks.")

;; ---------------------------------------------------------------------------
;; 2. Theme following — resolve muted colors from the active theme.
;; ---------------------------------------------------------------------------

(defun styx/org-callout--color-p (s)
  "Non-nil if S is a usable color string."
  (and (stringp s)
       (not (string-prefix-p "unspecified" s))))

(defun styx/org-callout--face-fg (face fallback)
  "Foreground of FACE, or FALLBACK."
  (let ((v (and (facep face) (face-attribute face :foreground nil 'default))))
    (if (styx/org-callout--color-p v) v fallback)))

(defun styx/org-callout--doom (name)
  "Doom theme color NAME via `doom-color', or nil."
  (when (fboundp 'doom-color)
    (let ((v (ignore-errors (doom-color name))))
      (when (styx/org-callout--color-p v) v))))

(defun styx/org-callout--parse-hex (color)
  "Parse #RRGGBB COLOR to (R G B) in 0-255, or nil."
  (when (and (stringp color)
             (string-match "\\`#\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\([0-9a-fA-F]\\{2\\}\\)\\'" color))
    (list (string-to-number (match-string 1 color) 16)
          (string-to-number (match-string 2 color) 16)
          (string-to-number (match-string 3 color) 16))))

(defun styx/org-callout--mix (accent base alpha)
  "Mix ACCENT toward BASE by ALPHA (0.0-1.0). Returns hex string.
Parses hex directly so it works in batch as well as GUI; falls back
to `color-values' for named colors, else returns ACCENT unchanged."
  (let ((ca (or (styx/org-callout--parse-hex accent)
                (let ((v (ignore-errors (color-values accent))))
                  (when v (mapcar (lambda (x) (/ x 257.0)) v)))))
        (cb (or (styx/org-callout--parse-hex base)
                (let ((v (ignore-errors (color-values base))))
                  (when v (mapcar (lambda (x) (/ x 257.0)) v))))))
    (if (and ca cb)
        (apply #'format "#%02x%02x%02x"
               (cl-mapcar (lambda (a b)
                            (round (+ (* alpha a) (* (- 1.0 alpha) b))))
                          ca cb))
      accent)))

(defun styx/org-callout--accent (type)
  "Muted accent color for callout TYPE from the active theme."
  (let ((fallback (cdr (assoc type styx/org-callout--fallback-accents))))
    (pcase type
      ("note"
       (or (styx/org-callout--doom 'magenta)
           (styx/org-callout--doom 'violet)
           (styx/org-callout--face-fg 'font-lock-type-face fallback)
           fallback))
      ("tip"
       (or (styx/org-callout--doom 'green)
           (styx/org-callout--doom 'teal)
           (styx/org-callout--face-fg 'font-lock-string-face fallback)
           (styx/org-callout--face-fg 'success fallback)
           fallback))
      ("warning"
       (or (styx/org-callout--doom 'yellow)
           (styx/org-callout--doom 'orange)
           (styx/org-callout--face-fg 'warning fallback)
           fallback))
      (_ ; important, caution
       (or (styx/org-callout--doom 'red)
           (styx/org-callout--face-fg 'error fallback)
           fallback)))))

(defun styx/org-callout--theme-bg ()
  "Current background, or a muted dark fallback."
  (let ((v (face-attribute 'default :background nil 'default)))
    (if (styx/org-callout--color-p v) v "#1f1d2e")))

(defun styx/org-callout--theme-fg ()
  "Current foreground, or a muted light fallback."
  (let ((v (face-attribute 'default :foreground nil 'default)))
    (if (styx/org-callout--color-p v) v "#e0def4")))

(defvar styx/org-callout--current-accents nil
  "Last computed ((type accent tinted-bg) ...) list, for HTML export sync.")

(defun styx/org-callout--refresh ()
  "Recompute muted callout faces from the active theme.
Body = theme bg tinted ~10% toward the type accent; text = theme fg;
delimiters = same tint with accent-colored bold text."
  (let ((bg (styx/org-callout--theme-bg))
        (fg (styx/org-callout--theme-fg))
        (alpha (max 0.0 (min 1.0 styx/org-callout-blend)))
        (pairs '(("note" styx/org-callout-note-body styx/org-callout-note-delimiter)
                 ("tip" styx/org-callout-tip-body styx/org-callout-tip-delimiter)
                 ("warning" styx/org-callout-warning-body styx/org-callout-warning-delimiter)
                 ("important" styx/org-callout-important-body styx/org-callout-important-delimiter)
                 ("caution" styx/org-callout-caution-body styx/org-callout-caution-delimiter)))
        accs)
    (dolist (p pairs)
      (let* ((type (nth 0 p))
             (accent (styx/org-callout--accent type))
             (tint (styx/org-callout--mix accent bg alpha)))
        (push (list type accent tint) accs)
        (set-face-attribute (nth 1 p) nil
                            :background tint :foreground fg :extend t)
        (set-face-attribute (nth 2 p) nil
                            :background tint :foreground accent
                            :weight 'bold :extend t)))
    (setq styx/org-callout--current-accents (nreverse accs))
    (styx/org-callout--update-html)))

(defun styx/org-callout--on-theme (&rest _)
  "Theme-change entry point (ignores hook args)."
  (styx/org-callout--refresh))

;; ---------------------------------------------------------------------------
;; 3. Fontification via multiline font-lock matchers (unchanged).
;; ---------------------------------------------------------------------------

(defun styx/org-callout--find (type limit)
  "Search for #+begin_TYPE ... #+end_TYPE before LIMIT.
Set match-data to (whole begin-line body end-line) and return t if found.
TYPE is matched case-insensitively, e.g. \"note\"."
  (let ((case-fold-search t)
        (begin-re (format "^[ \t]*#\\+begin_%s\\b.*$" type))
        (end-re (format "^[ \t]*#\\+end_%s\\b.*$" type)))
    (when (re-search-forward begin-re limit t)
      (let ((beg-line-start (match-beginning 0))
            (beg-line-end (min (1+ (match-end 0)) (point-max))))
        (if (re-search-forward end-re nil t)
            (let ((end-line-start (match-beginning 0))
                  (end-line-end (min (1+ (match-end 0)) (point-max))))
              (set-match-data
               (list beg-line-start end-line-end
                     beg-line-start beg-line-end
                     beg-line-end end-line-start
                     end-line-start end-line-end))
              (goto-char end-line-end)
              t)
          ;; Unclosed block: fontify begin line + rest up to LIMIT as body.
          (let ((body-end (min (max beg-line-end limit) (point-max))))
            (set-match-data
             (list beg-line-start body-end
                   beg-line-start beg-line-end
                   beg-line-end body-end
                   body-end body-end))
            (goto-char body-end)
            t))))))

(defun styx/org-callout-note-matcher (limit)
  (styx/org-callout--find "note" limit))
(defun styx/org-callout-tip-matcher (limit)
  (styx/org-callout--find "tip" limit))
(defun styx/org-callout-warning-matcher (limit)
  (styx/org-callout--find "warning" limit))
(defun styx/org-callout-important-matcher (limit)
  (styx/org-callout--find "important" limit))
(defun styx/org-callout-caution-matcher (limit)
  (styx/org-callout--find "caution" limit))

(defvar styx/org-callout--font-lock-keywords
  '((styx/org-callout-note-matcher
     (1 'styx/org-callout-note-delimiter t t)
     (2 'styx/org-callout-note-body t t)
     (3 'styx/org-callout-note-delimiter t t))
    (styx/org-callout-tip-matcher
     (1 'styx/org-callout-tip-delimiter t t)
     (2 'styx/org-callout-tip-body t t)
     (3 'styx/org-callout-tip-delimiter t t))
    (styx/org-callout-warning-matcher
     (1 'styx/org-callout-warning-delimiter t t)
     (2 'styx/org-callout-warning-body t t)
     (3 'styx/org-callout-warning-delimiter t t))
    (styx/org-callout-important-matcher
     (1 'styx/org-callout-important-delimiter t t)
     (2 'styx/org-callout-important-body t t)
     (3 'styx/org-callout-important-delimiter t t))
    (styx/org-callout-caution-matcher
     (1 'styx/org-callout-caution-delimiter t t)
     (2 'styx/org-callout-caution-body t t)
     (3 'styx/org-callout-caution-delimiter t t)))
  "Font-lock keywords for callout special blocks.")

(defun styx/org-callout--enable ()
  "Enable multiline font-lock so callout bodies can span lines."
  (setq-local font-lock-multiline t))

;; Register with Org. Guard against double-adding on reload.
(after! org
  (font-lock-add-keywords 'org-mode styx/org-callout--font-lock-keywords 'append)
  (add-hook 'org-mode-hook #'styx/org-callout--enable)
  ;; Refontify already-open Org buffers after reload.
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (derived-mode-p 'org-mode)
        (setq-local font-lock-multiline t)
        (font-lock-flush)))))

;; Follow theme switches (Doom + vanilla). Initial apply happens at end
;; of file, after the HTML sync helpers are defined.
(when (boundp 'doom-load-theme-hook)
  (add-hook 'doom-load-theme-hook #'styx/org-callout--on-theme))
(when (boundp 'enable-theme-functions)
  (add-hook 'enable-theme-functions #'styx/org-callout--on-theme))
(when (fboundp 'advice-add)
  (unless (advice-member-p #'styx/org-callout--on-theme 'load-theme)
    (advice-add 'load-theme :after #'styx/org-callout--on-theme)))

;; ---------------------------------------------------------------------------
;; 4. HTML export — regenerated from the live palette on every refresh.
;;    Org already exports #+begin_note as <div class="note">, so we only
;;    supply CSS.  Appends to org-html-head-extra (style.el owns
;;    org-html-head, don't clobber); old styx block is replaced, not duped.
;; ---------------------------------------------------------------------------

(defvar styx/org-callout-html-marker-begin "<!-- styx-callouts-begin -->"
  "Marker opening the styx callout CSS block in `org-html-head-extra'.")
(defvar styx/org-callout-html-marker-end "<!-- styx-callouts-end -->"
  "Marker closing the styx callout CSS block in `org-html-head-extra'.")

(defun styx/org-callout--html-css ()
  "Build muted callout CSS from the current palette."
  (let* ((fg (styx/org-callout--theme-fg))
         (get (lambda (type)
                (or (nth 1 (assoc type styx/org-callout--current-accents))
                    (cdr (assoc type styx/org-callout--fallback-accents)))))
         (bg-for (lambda (type)
                   (or (nth 2 (assoc type styx/org-callout--current-accents))
                       (styx/org-callout--mix (funcall get type)
                                              (styx/org-callout--theme-bg)
                                              styx/org-callout-blend)))))
    (format "%s\n<style type=\"text/css\">
.callout, div.note, div.tip, div.warning, div.important, div.caution {
  border-radius: 8px; padding: 0.6em 1em; margin: 1em 0;
  border-left: 5px solid; }
div.note { background: %s; border-color: %s; color: %s; }
div.tip { background: %s; border-color: %s; color: %s; }
div.warning { background: %s; border-color: %s; color: %s; }
div.important, div.caution { background: %s; border-color: %s; color: %s; }
</style>\n%s"
            styx/org-callout-html-marker-begin
            (funcall bg-for "note") (funcall get "note") fg
            (funcall bg-for "tip") (funcall get "tip") fg
            (funcall bg-for "warning") (funcall get "warning") fg
            (funcall bg-for "important") (funcall get "important") fg
            styx/org-callout-html-marker-end)))

(defun styx/org-callout--update-html ()
  "Insert or replace the styx CSS block in `org-html-head-extra'."
  (when (boundp 'org-html-head-extra)
    (let ((css (styx/org-callout--html-css))
          (old (and (boundp 'org-html-head-extra) org-html-head-extra)))
      (setq org-html-head-extra
            (if (and (stringp old)
                     (string-match-p (regexp-quote styx/org-callout-html-marker-begin) old))
                (replace-regexp-in-string
                 (concat (regexp-quote styx/org-callout-html-marker-begin)
                         "\\(?:.\\|\n\\)*?"
                         (regexp-quote styx/org-callout-html-marker-end))
                 (lambda (_) css) old t t)
              (concat (or old "") "\n" css))))))

(after! ox-html
  (styx/org-callout--update-html))

;; ---------------------------------------------------------------------------
;; 5. LaTeX export (static muted — paper has no live theme).
;;    Org exports #+begin_note as \\begin{note}...\\end{note}, so define
;;    those environments with muted tcolorbox colors comparable to the
;;    Doom palettes (dusty, low-saturation).
;; ---------------------------------------------------------------------------

(defvar styx/org-callout-latex-preamble
  "\\usepackage{tcolorbox}
\\newtcolorbox{note}{colback=#E7E2EE,colframe=#8E7FAE,coltext=#2E2438,arc=3mm,boxrule=0.6mm,leftrule=2.5mm}
\\newtcolorbox{tip}{colback=#DDE7E2,colframe=#6F9B8A,coltext=#1E2E28,arc=3mm,boxrule=0.6mm,leftrule=2.5mm}
\\newtcolorbox{warning}{colback=#ECE0C3,colframe=#A8894A,coltext=#3A2C12,arc=3mm,boxrule=0.6mm,leftrule=2.5mm}
\\newtcolorbox{important}{colback=#E9D2D2,colframe=#A95F5F,coltext=#3A1A1A,arc=3mm,boxrule=0.6mm,leftrule=2.5mm}
\\newtcolorbox{caution}{colback=#E9D2D2,colframe=#A95F5F,coltext=#3A1A1A,arc=3mm,boxrule=0.6mm,leftrule=2.5mm}
"
  "LaTeX preamble defining note/tip/warning/important/caution environments.")

(after! ox-latex
  (add-to-list 'org-latex-packages-alist '("" "tcolorbox" t))
  (let ((pre styx/org-callout-latex-preamble))
    (cond
     ((bound-and-true-p org-latex-preamble)
      (unless (string-match-p "newtcolorbox{note}" org-latex-preamble)
        (setq org-latex-preamble (concat org-latex-preamble "\n" pre))))
     (t (setq org-latex-preamble pre)))))

;; Initial apply (after all helpers above are defined).
(styx/org-callout--refresh)

(provide 'styx)
