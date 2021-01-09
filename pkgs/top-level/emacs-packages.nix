# package.el-based emacs packages

## FOR USERS
#
# Recommended: simply use `emacsWithPackages` with the packages you want.
#
# Alternative: use `emacs`, install everything to a system or user profile
# and then add this at the start your `init.el`:
/*
  (require 'package)

  ;; optional. makes unpure packages archives unavailable
  (setq package-archives nil)

  ;; optional. use this if you install emacs packages to the system profile
  (add-to-list 'package-directory-list "/run/current-system/sw/share/emacs/site-lisp/elpa")

  ;; optional. use this if you install emacs packages to user profiles (with nix-env)
  (add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

  (package-initialize)
*/

## FOR CONTRIBUTORS
#
# When adding a new package here please note that
# * please use `elpaBuild` for pre-built package.el packages and
#   `melpaBuild` or `trivialBuild` if the package must actually
#   be built from the source.
# * lib.licenses are `with`ed on top of the file here
# * both trivialBuild and melpaBuild will automatically derive a
#   `meta` with `platforms` and `homepage` set to something you are
#   unlikely to want to override for most packages

{ lib, newScope, stdenv, fetchurl, fetchFromGitHub, runCommand, writeText

, emacs, texinfo, lndir, makeWrapper
, trivialBuild
, melpaBuild

, external
, pkgs
}:

let

  mkElpaPackages = import ../applications/editors/emacs-modes/elpa-packages.nix {
    inherit lib stdenv texinfo;
  };

  # Contains both melpa stable & unstable
  melpaGeneric = import ../applications/editors/emacs-modes/melpa-packages.nix {
    inherit external lib pkgs;
  };
  mkMelpaStablePackages = melpaGeneric "stable";
  mkMelpaPackages = melpaGeneric "unstable";

  mkOrgPackages = import ../applications/editors/emacs-modes/org-packages.nix {
    inherit lib;
  };

  emacsWithPackages = import ../build-support/emacs/wrapper.nix {
    inherit lib lndir makeWrapper runCommand;
  };

  mkManualPackages = import ../applications/editors/emacs-modes/manual-packages.nix {
    inherit external lib pkgs;
  };

in lib.makeScope newScope (self: lib.makeOverridable ({
  elpaPackages ? mkElpaPackages self
  , melpaStablePackages ? mkMelpaStablePackages self
  , melpaPackages ? mkMelpaPackages self
  , orgPackages ? mkOrgPackages self
  , manualPackages ? mkManualPackages self
}: ({}
  // elpaPackages // { inherit elpaPackages; }
  // melpaStablePackages // { inherit melpaStablePackages; }
  // melpaPackages // { inherit melpaPackages; }
  // orgPackages // { inherit orgPackages; }
  // manualPackages // { inherit manualPackages; }
  // {
    inherit emacs melpaBuild trivialBuild;
    emacsWithPackages = emacsWithPackages self;
  })
) {})
