# package.el-based emacs packages

## FOR USERS
#
# Recommended: simply use `emacsWithPackages` with the packages you want.
#
# Alternative: use `emacs`, install everything to a system or user profile
# and then add this at the start your `early-init.el`:
/*
  ;; optional. use this if you install emacs packages to the system profile
  (add-to-list 'package-directory-list "/run/current-system/sw/share/emacs/site-lisp/elpa")

  ;; optional. use this if you install emacs packages to user profiles (with nix-env)
  (add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")
*/

{ pkgs'
, emacs'
, makeScope
, makeOverridable
, dontRecurseIntoAttrs
}:

let

  mkElpaDevelPackages = { pkgs, lib }: import ../applications/editors/emacs/elisp-packages/elpa-devel-packages.nix {
    inherit (pkgs) stdenv texinfo writeText gcc pkgs buildPackages;
    inherit lib;
  };

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

  emacsWithPackages = { pkgs, lib }: pkgs.callPackage ../build-support/emacs/wrapper.nix {
    inherit (pkgs.xorg) lndir;
    inherit lib;
  };

in makeScope pkgs'.newScope (self: makeOverridable ({
  pkgs ? pkgs'
  , lib ? pkgs.lib
  , elpaDevelPackages ? mkElpaDevelPackages { inherit pkgs lib; } self
  , elpaPackages ? mkElpaPackages { inherit pkgs lib; } self
  , nongnuPackages ? mkNongnuPackages { inherit pkgs lib; } self
  , melpaStablePackages ? melpaGeneric { inherit pkgs lib; } "stable" self
  , melpaPackages ? melpaGeneric { inherit pkgs lib; } "unstable" self
  , manualPackages ? mkManualPackages { inherit pkgs lib; } self
}: ({}
  // elpaDevelPackages // { inherit elpaDevelPackages; }
  // elpaPackages // { inherit elpaPackages; }
  // nongnuPackages // { inherit nongnuPackages; }
  // melpaStablePackages // { inherit melpaStablePackages; }
  // melpaPackages // { inherit melpaPackages; }
  // manualPackages // { inherit manualPackages; }
  // {

    # Propagate overridden scope
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

    # EXWM is not tagged very often, prefer it from elpa devel.
    inherit (elpaDevelPackages) exwm;

    # Telega uploads packages incompatible with stable tdlib to melpa
    # Prefer the one from melpa stable
    inherit (melpaStablePackages) telega;

  })
) {})
