;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(setq user-email-address "jan@jungnickel.com"
      user-full-name "Jan Jungnickel")

(setq doom-theme 'doom-one)

(setq doom-font (font-spec :family "Iosevka Nerd Font" :weight 'light :size 14)
      doom-variable-pitch-font (font-spec :family "Fira Sans")
      doom-unicode-font (font-spec :family "DejaVu Sans Mono")
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 24 :weight 'light))

(setq deft-directory "~/Documents/Notes")

(setq +format-on-save-enabled-modes
  '(not emacs-lisp-mode  ; elisp's mechanisms are good enough
        sql-mode         ; sqlformat is currently broken
        yaml-mode))      ; so is yaml-mode (for gitlab-ci and anchors)
