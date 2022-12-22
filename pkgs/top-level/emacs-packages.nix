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

{ pkgs'
, emacs'
, makeScope
, makeOverridable
, dontRecurseIntoAttrs
}:

let

  mkElpaPackages = { pkgs, lib }: import ../applications/editors/emacs/elisp-packages/elpa-packages.nix {
    inherit (pkgs) stdenv texinfo writeText gcc pkgs buildPackages;
    inherit lib;
  };

  mkNongnuPackages = { pkgs, lib }: import ../applications/editors/emacs/elisp-packages/nongnu-packages.nix {
    inherit (pkgs) buildPackages;
    inherit lib;
  };

  # Contains both melpa stable & unstable
  melpaGeneric = { pkgs, lib }: import ../applications/editors/emacs/elisp-packages/melpa-packages.nix {
    inherit lib pkgs;
  };

  mkManualPackages = { pkgs, lib }: import ../applications/editors/emacs/elisp-packages/manual-packages.nix {
    inherit lib pkgs;
  };

  emacsWithPackages = { pkgs, lib }: import ../build-support/emacs/wrapper.nix {
    inherit (pkgs) makeWrapper runCommand gcc;
    inherit (pkgs.xorg) lndir;
    inherit lib;
  };

in makeScope pkgs'.newScope (self: makeOverridable ({
  pkgs ? pkgs'
  , lib ? pkgs.lib
  , elpaPackages ? mkElpaPackages { inherit pkgs lib; } self
  , nongnuPackages ? mkNongnuPackages { inherit pkgs lib; } self
  , melpaStablePackages ? melpaGeneric { inherit pkgs lib; } "stable" self
  , melpaPackages ? melpaGeneric { inherit pkgs lib; } "unstable" self
  , manualPackages ? mkManualPackages { inherit pkgs lib; } self
}: ({}
  // elpaPackages // { inherit elpaPackages; }
  // nongnuPackages // { inherit nongnuPackages; }
  // melpaStablePackages // { inherit melpaStablePackages; }
  // melpaPackages // { inherit melpaPackages; }
  // manualPackages // { inherit manualPackages; }
  // {

    # Propagate overriden scope
    emacs = emacs'.overrideAttrs(old: {
      passthru = (old.passthru or {}) // {
        pkgs = dontRecurseIntoAttrs self;
      };
    });

    trivialBuild = pkgs.callPackage ../build-support/emacs/trivial.nix {
      inherit (self) emacs;
    };

    melpaBuild = pkgs.callPackage ../build-support/emacs/melpa.nix {
      inherit (self) emacs;
    };

    emacsWithPackages = emacsWithPackages { inherit pkgs lib; } self;
    withPackages = emacsWithPackages { inherit pkgs lib; } self;

  } // {

    # Package specific priority overrides goes here

    # Telega uploads packages incompatible with stable tdlib to melpa
    # Prefer the one from melpa stable
    inherit (melpaStablePackages) telega;

  })
) {})
