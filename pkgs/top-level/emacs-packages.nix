# package.el-based emacs packages

## FOR USERS
#
# Recommended: simply use `emacsWithPackages` with the packages you want.
#
# Alterative: use `emacs`, install everything to a system or user profile
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

with lib.licenses;

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

  mkOrgPackages = import ../applications/editors/emacs-modes/org-packages.nix { };

  emacsWithPackages = import ../build-support/emacs/wrapper.nix {
    inherit lib lndir makeWrapper stdenv runCommand;
  };

  mkManualPackages = self: with self; {

    elisp-ffi = melpaBuild rec {
      pname = "elisp-ffi";
      version = "1.0.0";
      src = fetchFromGitHub {
        owner = "skeeto";
        repo = "elisp-ffi";
        rev = "${version}";
        sha256 = "0z2n3h5l5fj8wl8i1ilfzv11l3zba14sgph6gz7dx7q12cnp9j22";
      };
      buildInputs = [ external.libffi ];
      preBuild = "make";
      recipe = writeText "recipe" ''
        (elisp-ffi
        :repo "skeeto/elisp-ffi"
        :fetcher github
        :files ("ffi-glue" "ffi.el"))
      '';
      meta = {
        description = "Emacs Lisp Foreign Function Interface";
        longDescription = ''
          This library provides an FFI for Emacs Lisp so that Emacs
          programs can invoke functions in native libraries. It works by
          driving a subprocess to do the heavy lifting, passing result
          values on to Emacs.
        '';
        license = publicDomain;
      };
    };

    agda2-mode = with external; trivialBuild {
      pname = "agda-mode";
      version = Agda.version;

      phases = [ "buildPhase" "installPhase" ];

      # already byte-compiled by Agda builder
      buildPhase = ''
        agda=`${Agda}/bin/agda-mode locate`
        cp `dirname $agda`/*.el* .
      '';

      meta = {
        description = "Agda2-mode for Emacs extracted from Agda package";
        longDescription = ''
          Wrapper packages that liberates init.el from `agda-mode locate` magic.
          Simply add this to user profile or systemPackages and do `(require 'agda2)` in init.el.
        '';
        homepage = Agda.meta.homepage;
        license = Agda.meta.license;
      };
    };

    ess-R-object-popup =
      callPackage ../applications/editors/emacs-modes/ess-R-object-popup { };

    filesets-plus = callPackage ../applications/editors/emacs-modes/filesets-plus { };

    font-lock-plus = callPackage ../applications/editors/emacs-modes/font-lock-plus { };

    ghc-mod = melpaBuild rec {
      pname = "ghc";
      version = external.ghc-mod.version;
      src = external.ghc-mod.src;
      packageRequires = [ haskell-mode ];
      propagatedUserEnvPkgs = [ external.ghc-mod ];
      recipe = writeText "recipe" ''
        (ghc-mod :repo "DanielG/ghc-mod" :fetcher github :files ("elisp/*.el"))
      '';
      fileSpecs = [ "elisp/*.el" ];
      meta = {
        description = "An extension of haskell-mode that provides completion of symbols and documentation browsing";
        license = bsd3;
      };
    };

    haskell-unicode-input-method = melpaBuild rec {
      pname = "emacs-haskell-unicode-input-method";
      version = "20110905.2307";
      src = fetchFromGitHub {
        owner = "roelvandijk";
        repo = "emacs-haskell-unicode-input-method";
        rev = "d8d168148c187ed19350bb7a1a190217c2915a63";
        sha256 = "09b7bg2s9aa4s8f2kdqs4xps3jxkq5wsvbi87ih8b6id38blhf78";
      };
      recipe = writeText "recipe" ''
        (haskell-unicode-input-method
         :repo "roelvandijk/emacs-haskell-unicode-input-method"
         :fetcher github)
      '';
      packageRequires = [];
      meta = {
        homepage = "https://melpa.org/#haskell-unicode-input-method/";
        license = lib.licenses.free;
      };
    };

    hexrgb = callPackage ../applications/editors/emacs-modes/hexrgb { };

    header2 = callPackage ../applications/editors/emacs-modes/header2 { };

    helm-words = callPackage ../applications/editors/emacs-modes/helm-words { };

    icicles = callPackage ../applications/editors/emacs-modes/icicles { };

    rtags = melpaBuild rec {
      inherit (external.rtags) version src meta;

      pname = "rtags";

      dontConfigure = true;

      propagatedUserEnvPkgs = [ external.rtags ];
      recipe = writeText "recipe" ''
        (rtags
         :repo "andersbakken/rtags" :fetcher github
         :files ("src/*.el"))
      '';
    };

    lib-requires =
      callPackage ../applications/editors/emacs-modes/lib-requires { };

    org-mac-link =
      callPackage ../applications/editors/emacs-modes/org-mac-link { };

    perl-completion =
      callPackage ../applications/editors/emacs-modes/perl-completion { };

    railgun = callPackage ../applications/editors/emacs-modes/railgun { };

    gn = callPackage ../applications/editors/emacs-modes/gn { };

    structured-haskell-mode = self.shm;

    thingatpt-plus = callPackage ../applications/editors/emacs-modes/thingatpt-plus { };

    tramp = callPackage ../applications/editors/emacs-modes/tramp { };

    yaoddmuse = callPackage ../applications/editors/emacs-modes/yaoddmuse { };

    zeitgeist = callPackage ../applications/editors/emacs-modes/zeitgeist { };

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
  // manualPackages
  // {
    inherit emacs melpaBuild trivialBuild;
    emacsWithPackages = emacsWithPackages self;
  })
) {})
