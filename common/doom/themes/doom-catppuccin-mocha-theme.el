;;; doom-catppuccin-mocha-theme.el --- A dark port of the Catppuccin Mocha theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Palette source: Catppuccin Mocha — https://github.com/catppuccin/catppuccin
;; Structure adapted from: doom-rose-pine-theme.el (donniebreve / mvllow)
;; Keywords: custom themes, faces
;; Package-Requires: ((emacs "25.1") (cl-lib "0.5") (doom-themes "2.2.1"))
;;
;;; Commentary:
;;
;; Thanks to the Catppuccin community (https://github.com/catppuccin/catppuccin) for the palette
;; Thanks to hlissner (https://github.com/doomemacs/themes)
;;
;;; Code:

(require 'doom-themes)

;;; Variables
(defgroup doom-catppuccin-mocha-theme nil
  "Options for the `doom-catppuccin-mocha' theme."
  :group 'doom-themes)

(defcustom doom-catppuccin-mocha-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-catppuccin-mocha-theme
  :type 'boolean)

(defcustom doom-catppuccin-mocha-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-catppuccin-mocha-theme
  :type 'boolean)

(defcustom doom-catppuccin-mocha-brighter-text nil
  "If non-nil, default text will be brighter."
  :group 'doom-catppuccin-mocha-theme
  :type 'boolean)

(defcustom doom-catppuccin-mocha-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to determine the exact padding."
  :group 'doom-catppuccin-mocha-theme
  :type '(choice integer boolean))

;;; Theme definition
(def-doom-theme doom-catppuccin-mocha
  "A dark port of the Catppuccin Mocha theme"
  :family 'doom-catppuccin-mocha
  :background-mode 'dark

  ;; Main theme colors
  (
    ;; name        default   256       16
    (base           '("#1E1E2E" "#262626" "black"       )) ; base
    (surface        '("#181825" "#1c1c1c" "black"       )) ; mantle
    (overlay        '("#313244" "#3a3a3a" "brightblack" )) ; surface0
    (muted          '("#6C7086" "#767676" "brightblack" )) ; overlay0
    (subtle         '("#9399B2" "#8787af" "white"       )) ; overlay2
    (text           '("#CDD6F4" "#d7d7ff" "brightwhite" )) ; text
    (love           '("#F38BA8" "#ff87af" "red"         )) ; red
    (gold           '("#F9E2AF" "#ffd7af" "yellow"      )) ; yellow
    (rose           '("#F5C2E7" "#ffafd7" "magenta"     )) ; pink
    (pine           '("#89B4FA" "#87afff" "brightblue"  )) ; blue
    (foam           '("#94E2D5" "#87d7d7" "brightcyan"  )) ; teal
    (iris           '("#CBA6F7" "#d7afff" "brightmagenta")) ; mauve
    (peach          '("#FAB387" "#ffaf87" "brightred"   )) ; peach
    (leaf           '("#A6E3A1" "#afd7af" "green"       )) ; green
    (sky            '("#89DCEB" "#87d7d7" "cyan"        )) ; sky
    (lavender       '("#B4BEFE" "#afafff" "magenta"     )) ; lavender
    (deep           '("#74C7EC" "#87d7ff" "blue"        )) ; sapphire
    (highlightL     '("#313244" "#3a3a3a" "brightblack" )) ; surface0
    (highlightM     '("#45475A" "#4e4e4e" "brightblack" )) ; surface1
    (highlightH     '("#585B70" "#626262" "brightblack" )) ; surface2

    ;; Variables required by doom theme
    ;; These are required by doom theme and used in various places
    (bg             base)
    (fg             (if doom-catppuccin-mocha-brighter-text (doom-lighten text 0.2) text))
    ;; These are off-color variants of bg/fg, used primarily for `solaire-mode',
    ;; but can also be useful as a basis for subtle highlights (e.g. for hl-line
    ;; or region), especially when paired with the `doom-darken', `doom-lighten',
    ;; and `doom-blend' helper functions.
    (bg-alt         surface)
    (fg-alt         (if doom-catppuccin-mocha-brighter-text (doom-lighten text 0.2) text))
    ;; These should represent a spectrum from bg to fg, where base0 is a starker
    ;; bg and base8 is a starker fg. For example, if bg is light grey and fg is
    ;; dark grey, base0 should be white and base8 should be black.
    (base0          base)
    (base1          surface)
    (base2          highlightL)
    (base3          overlay)
    (base4          highlightM)
    (base5          highlightH)
    (base6          muted)
    (base7          subtle)
    (base8          text)
    (grey           muted)
    (red            love)
    (orange         peach)
    (green          leaf)
    (teal           foam)
    (yellow         gold)
    (blue           pine)
    (dark-blue      deep)
    (magenta        iris)
    (violet         lavender)
    (cyan           sky)
    (dark-cyan      foam)
    ;; Variables required by doom theme ends here

    ;; Required face categories for syntax highlighting
    (highlight      subtle)
    (selection      highlightM)
    (region         highlightM)  ; visual selection
    (vertical-bar   surface)  ; window split

    (comments       (if doom-catppuccin-mocha-brighter-comments subtle muted))
    (doc-comments   (if doom-catppuccin-mocha-brighter-comments subtle muted))

    (builtin        pine)
    (constants      peach)
    (functions      pine)
    (keywords       iris)
    (methods        foam)
    (numbers        peach)
    (operators      sky)
    (strings        leaf)
    (type           gold)
    (variables      lavender)

    (error          love)
    (success        leaf)
    (warning        gold)

    (vc-added       leaf)
    (vc-deleted     love)
    (vc-modified    gold)

    ;; Other categories
    ;; Modeline
    (modeline-bg                 (if doom-catppuccin-mocha-brighter-modeline overlay surface))
    (modeline-fg                 text)
    (modeline-bg-alt             (if doom-catppuccin-mocha-brighter-modeline muted overlay))
    (modeline-fg-alt             text) ; should this be darker or lighter?
    (modeline-bg-inactive        base)
    (modeline-fg-inactive        subtle)
    (modeline-bg-inactive-alt    base)
    (modeline-fg-inactive-alt    subtle)
    (-modeline-pad
      (when doom-catppuccin-mocha-padded-modeline
        (if (integerp doom-catppuccin-mocha-padded-modeline) doom-catppuccin-mocha-padded-modeline 4))))

  ;; Base theme face overrides
  (
    ;; Font
    ((font-lock-comment-face &override)
      :slant 'italic
      :background (if doom-catppuccin-mocha-brighter-comments (doom-blend teal base 0.07)))
    ((font-lock-type-face &override) :slant 'italic)
    ((font-lock-builtin-face &override) :slant 'italic)
    ((font-lock-function-name-face &override) :foreground type)
    ((font-lock-keyword-face &override) :weight 'bold)
    ((font-lock-constant-face &override) :weight 'bold)

    ;; Highlight line
    (hl-line
       :background surface)

    ;; Line numbers
    ((line-number &override) :foreground muted)
    ((line-number-current-line &override) :foreground text)

    ;; Mode line
    (mode-line
      :background modeline-bg
      :foreground modeline-fg
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
    (mode-line-inactive
      :background modeline-bg-inactive
      :foreground modeline-fg-inactive
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
    (mode-line-emphasis
      :foreground (if doom-catppuccin-mocha-brighter-modeline text subtle))

    ;; Company
    (company-tooltip-selection :background selection :foreground fg :weight 'bold)

    ;; CSS mode <built-in> / scss-mode
    (css-proprietary-property :foreground orange)
    (css-property             :foreground green)
    (css-selector             :foreground green)

    ;; Doom mode line
    (doom-modeline-bar :background green) ; The line to the left
    (doom-modeline-evil-emacs-state  :foreground magenta)  ; The dot color when in emacs mode
    (doom-modeline-evil-normal-state :foreground green)    ; The dot color when in normal mode
    (doom-modeline-evil-visual-state :foreground magenta)  ; The dot color when in visual mode
    (doom-modeline-evil-insert-state :foreground orange)   ; The dot color when in insert mode

    ;; Helm
    (helm-selection :background selection :foreground fg :weight 'bold)

    ;; Ivy
    (ivy-current-match :background overlay :distant-foreground fg)
    (ivy-minibuffer-match-face-1 :foreground pine :background nil :weight 'bold)
    (ivy-minibuffer-match-face-2 :foreground iris :background nil :weight 'bold)
    (ivy-minibuffer-match-face-3 :foreground gold :background nil :weight 'bold)
    (ivy-minibuffer-match-face-4 :foreground rose :background nil :weight 'bold)
    (ivy-minibuffer-match-highlight :foreground magenta :weight 'bold)
    (ivy-posframe :background modeline-bg-alt)

    ;; Markdown mode
    (markdown-markup-face :foreground text)
    (markdown-header-face :inherit 'bold :foreground red)
    ((markdown-code-face &override) :background surface)

    ;; org <built-in>
    (org-block :background (doom-blend yellow bg 0.04) :extend t)
    (org-block-begin-line :background (doom-blend yellow bg 0.04) :foreground comments :extend t)
    (org-block-end-line :background (doom-blend yellow bg 0.04) :foreground comments :extend t)
    (org-level-1 :foreground gold)
    (org-level-2 :foreground rose)
    (org-level-3 :foreground pine)
    (org-level-4 :foreground iris)
    (org-level-5 :foreground gold)
    (org-level-6 :foreground rose)
    (org-level-7 :foreground pine)
    (org-level-8 :foreground iris)

    ;; Solaire mode line
    (solaire-mode-line-face
      :inherit 'mode-line
      :background modeline-bg-alt
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
    (solaire-mode-line-inactive-face
      :inherit 'mode-line-inactive
      :background modeline-bg-inactive-alt
      :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

    ;; Widget
    (widget-field :foreground fg :background bg-alt)
    (widget-single-line-field :foreground fg :background bg-alt)

    ;; Swiper
    (swiper-match-face-1 :inherit 'ivy-minibuffer-match-face-1)
    (swiper-match-face-2 :inherit 'ivy-minibuffer-match-face-2)
    (swiper-match-face-3 :inherit 'ivy-minibuffer-match-face-3)
    (swiper-match-face-4 :inherit 'ivy-minibuffer-match-face-4)))

;;; doom-catppuccin-mocha-theme.el ends here
