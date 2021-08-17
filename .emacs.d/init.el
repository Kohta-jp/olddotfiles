;;; init.el --- Initializeation file for Emacs

;; Author: Shimasan <shimalog.d@gmail.com>

;;; Commentary:

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;
;; Load-Path Settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; load-path追加する関数を定義(.emacs.d以下のディレクトリ名だけで済むようにした)
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
     (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
         (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
             (normal-top-level-add-subdirs-to-load-path))))))



;; 引数のディレクトリとそのサブディレクトリをload-pathに追加

(add-to-load-path "elisp" "conf" "public_repos")

;;;;;;;;;;;;;;;;
;; File split ;;
;;;;;;;;;;;;;;;;

;; カスタムファイルを別のファイルに
(setq custom-file (locate-user-emacs-file "custom.el"))
;; カスタムファイルがない場合は作成する
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
;; カスタムファイルを読み込む
(load custom-file)

;; Mr.IMAKADO

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf") ; 設定ファイルがあるディレクトリを指定


;;;;;;;;;;;;;;;
;; Macintosh ;;
;;;;;;;;;;;;;;;

(when (eq system-type 'darwin)
   ;; macのファイル名を正しく扱う設定
   (require 'ucs-normalize)
   (setq file-name-coding-system 'utf-8-hfs)
   (setq locale-coding-system 'utf-8-hts))


;;;;;;;;;;;;;;;;;;;;;;;;
;; Key Binds Settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; C-h-->BackSpace

(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; C-h(help)を別に設定

(define-key global-map (kbd "C-x ?") 'help-command)

(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)


;;;;;;;;;;;;;;;;;;;;
;; Flame Settings ;;
;;;;;;;;;;;;;;;;;;;;

;; Dashbord settings +++++++++++++++++++++++++++++++++++++++++++
(require 'dashboard)
(dashboard-setup-startup-hook)
;; Set the title
;; Set the title
(when (eq system-type 'darwin)
  (setq dashboard-banner-logo-title
        (concat "GNU Emacs " emacs-version " kernel "
                (car (split-string (shell-command-to-string "uname -r")))  " x86_64 Mac OS X "
                (car(split-string (shell-command-to-string "sw_vers -productVersion") "-")))))
(when (eq system-type 'gnu/linux)
  (setq dashboard-banner-logo-title
        (concat "GNU Emacs " emacs-version " kernel "
                (car (split-string (shell-command-to-string "uname -r")))  " x86_64 Debian GNU/Linux "
                (car (split-string (shell-command-to-string "cat /etc/debian_version") "_")))))

;; Set the banner
(setq dashboard-startup-banner "~/.emacs.d/emacs.png")
(setq dashboard-set-navigator t)

;; Icons
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(dashboard-modify-heading-icons '((recents . "file-text")
                                  (bookmarks . "book")))



;; Format: "(icon title help action face prefix suffix)"
(setq dashboard-navigator-buttons
      `(;; line1
        ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
         "Homepage"
         "Browse homepage"
         (lambda (&rest _) (browse-url "homepage")))
        ("★" "Star" "Show stars" (lambda (&rest _) (show-stars)) warning)
        ("?" "" "?/h" #'show-help nil "<" ">"))))

(setq dashboard-set-init-info t)
(setq dashboard-init-info "This is an init message!")
(setq dashboard-set-footer nil)
(setq dashboard-footer-messages '("Dashboard is pretty cool!"))
(setq dashboard-footer-icon (all-the-icons-octicon "dashboard"
                                                   :height 1.1
                                                   :v-adjust -0.05
                                                   :face 'font-lock-keyword-face))

;; agenda

(add-to-list 'dashboard-items '(agenda) t)
(setq dashboard-week-agenda t)
(setq dashboard-org-agenda-categories '("Tasks" "Appointments"))
(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)


;; Region Settings++++++++++++++++++++++++++++++++++++++++++++++

(set-face-background 'region "SkyBlue")

;; ++++++++++Mode-Line++++++++++

;; powerline settings ++++++++++++++++++++++++++++++++++++++++++


;; カラム番号の表示++++++++++++++++++++++++++++++++++++++++++++++++

(column-number-mode t)

;; ファイルサイズの表示+++++++++++++++++++++++++++++++++++++++++++++

(size-indication-mode t)

;; Total-lines++++++++++++++++++++++++++++++++++++++++++++++++++

;; ++++++++++Title-Bar++++++++++

(setq frame-title-format
      (if (buffer-file-name)
	  (format "%%f --We think too much and feel too little.")
	(format "%%b --We think too much and feel too little.")))


;; ++++++++++Window++++++++++

(global-linum-mode t)

;; ++++++++++Font++++++++++

(set-face-attribute 'default nil :family "HackGen35Nerd" :height 135)

;; Icon


;;;;;;;;;;
;; Hook ;;
;;;;;;;;;;

;; ファイルが#!から始まるとき+xの実行権を与えて保存

(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)

;; 無名関数lamda
;; emacs-lisp-modeのフックのセット




;;;;;;;;;;;;;;;;;;;
;; リポジトリの設定 ;;
;;;;;;;;;;;;;;;;;;;

(require 'package)

;; package-archivesを上書き
;; パッケージリポジトリにMarmaladeとMELPAを追加
(add-to-list
 'package-archives
 '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/"))
;; 初期化
(package-initialize)			;インストール済みのElispを読み込む


;;;;;;;;;;;;;;;;;;;;
;; Theme Settings ;;
;;;;;;;;;;;;;;;;;;;;

;; Themeは目に優しいこいつ
(load-theme 'zenburn t)



;;;;;;;;;;;;;;;;;;;;;;;
;; Packages Settings ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; indent
(require 'indent-guide)
(indent-guide-global-mode)

;; LSP-Mode +++++++++++++++++++++++++++++++++++++++++++++++++++++




;; use-package(https://github.com/jwiegley/use-package)++++++++++
;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))



;; helm++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(require 'helm-config)


;; company（補完機能）+++++++++++++++++++++++++++++++++++++++++++++

(require 'company)
(global-company-mode) ; 全バッファで有効にする
(setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 3) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n, C-pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む
(define-key company-active-map (kbd "C-i") 'company-complete-selection) ;; C-iで候補を設定
(define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map (kbd "C-f") 'company-complete-selection) ;; C-fで候補を設定
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete) ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う

;; company-box

(require 'company-box)
(add-hook 'company-mode-hook 'company-box-mode)

;; counsel+++++++++++++++++++++++++++++++++++++++++++++++++++++++

(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; find-fileもcounsel任せ！
(setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))

;; ivy設定 ++++++++++++++++++++++++++++++++++++++++++++++++++++++

(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 10) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))

;; swiper++++++++++++++++++++++++++++++++++++++++++++++++++++++++

(global-set-key "\C-s" 'swiper)
(setq swiper-include-line-number-in-search t) ;; line-numberでも検索可能

;; neotree+++++++++++++++++++++++++++++++++++++++++++++++++++++++

(use-package neotree
  :init
  (setq-default neo-keymap-style 'concise)
  :config
  (setq neo-smart-open t)
  (setq neo-create-file-auto-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (bind-key [f8] 'neotree-toggle)
  (bind-key "RET" 'neotree-enter-hide neotree-mode-map)
  (bind-key "a" 'neotree-hidden-file-toggle neotree-mode-map)
  (bind-key "<left>" 'neotree-select-up-node neotree-mode-map)
  (bind-key "<right>" 'neotree-change-root neotree-mode-map))


;; Change neotree's font size
;; Tips from https://github.com/jaypei/emacs-neotree/issues/218
(defun neotree-text-scale ()
  "Text scale for neotree."
  (interactive)
  (text-scale-adjust 0)
  (text-scale-decrease 1)
  (message nil))
(add-hook 'neo-after-create-hook
      (lambda (_)
        (call-interactively 'neotree-text-scale)))

;; neotree enter hide
;; Tips from https://github.com/jaypei/emacs-neotree/issues/77
(defun neo-open-file-hide (full-path &optional arg)
  "Open file and hiding neotree.
The description of FULL-PATH & ARG is in `neotree-enter'."
  (neo-global--select-mru-window arg)
  (find-file full-path)
  (neotree-hide))

(defun neotree-enter-hide (&optional arg)
  "Neo-open-file-hide if file, Neo-open-dir if dir.
The description of ARG is in `neo-buffer--execute'."
  (interactive "P")
  (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))



;;;;;;;;;;;;;;;;
;; Programing ;;
;;;;;;;;;;;;;;;;

;; smartpatarns++++++++++++++++++++++++++++++++++++++++++++
(require 'smartparens-config)
(smartparens-global-mode t)

;; WEB-mode++++++++++++++++++++++++++++++++++++++++++++++++++++++

(when (require 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  )

;; JSにはjs2-modeを適用 Thank you ,Steve Yegge!+++++++++++++++++++

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; flycheck と flycheck-pos-tip++++++++++++++++++++++++++++++++++

(add-hook 'after-init-hook #'global-flycheck-mode)

(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))



;;; init.el ends here
