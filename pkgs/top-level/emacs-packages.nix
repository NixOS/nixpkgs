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

{ lib, newScope, stdenv, fetchurl, fetchgit, fetchFromGitHub, fetchhg, runCommand

, emacs, texinfo, lndir, makeWrapper
, trivialBuild
, melpaBuild

, external
}@args:

with lib.licenses;

let

  elpaPackages = import ../applications/editors/emacs-modes/elpa-packages.nix {
    inherit fetchurl lib stdenv texinfo;
  };

  melpaStablePackages = import ../applications/editors/emacs-modes/melpa-stable-packages.nix {
    inherit lib;
  };

  melpaPackages = import ../applications/editors/emacs-modes/melpa-packages.nix {
    inherit external lib;
  };

  orgPackages = import ../applications/editors/emacs-modes/org-packages.nix {
    inherit fetchurl lib stdenv texinfo;
  };

  emacsWithPackages = import ../build-support/emacs/wrapper.nix {
    inherit lib lndir makeWrapper stdenv runCommand;
  };

  packagesFun = self: with self; {

  inherit emacs melpaBuild trivialBuild;

  emacsWithPackages = emacsWithPackages self;

  ## START HERE

  pdf-tools = melpaBuild rec {
    pname = "pdf-tools";
    version = "0.80";
    src = fetchFromGitHub {
      owner = "politza";
      repo = "pdf-tools";
      rev = "v${version}";
      sha256 = "1i4647vax5na73basc5dz4lh9kprir00fh8ps4i0l1y3ippnjs2s";
    };
    nativeBuildInputs = [ external.pkgconfig ];
    buildInputs = with external; [ autoconf automake libpng zlib poppler ];
    preBuild = "make server/epdfinfo";
    fileSpecs = [ "lisp/pdf-*.el" "server/epdfinfo" ];
    packageRequires = [ tablist let-alist ];
    meta = {
      description = "Emacs support library for PDF files";
      license = gpl3;
    };
  };

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
    files = [ "ffi-glue" "ffi.el" ];
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

  elpy = melpaBuild rec {
    pname   = "elpy";
    version = external.elpy.version;
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = pname;
      rev    = "39ea47c73f040ce8dcc1c2d2639ebc0eb57ab8c8";
      sha256 = "0q3av1qv4m6aj4bil608f688hjpr5px8zqnnrdqx784nz98rpjrs";
    };

    patchPhase = ''
      for file in elpy.el elpy-pkg.el; do
        substituteInPlace $file \
            --replace "company \"0.8.2\"" "company \"${company.version}\"" \
            --replace "find-file-in-project \"3.3\"" "find-file-in-project \"${find-file-in-project.version}\"" \
            --replace "highlight-indentation \"0.5.0\"" "highlight-indentation \"${highlight-indentation.version}\"" \
            --replace "pyvenv \"1.3\"" "pyvenv \"${pyvenv.version}\"" \
            --replace "yasnippet \"0.8.0\"" "yasnippet \"${yasnippet.version}\""
     done
    '';

    packageRequires = [
      company find-file-in-project highlight-indentation pyvenv yasnippet
    ];

    propagatedUserEnvPkgs = [ external.elpy ] ++ packageRequires;

    meta = {
      description = "Emacs Python Development Environment";
      longDescription = ''
        Elpy is an Emacs package to bring powerful Python editing to Emacs.
        It combines a number of other packages, both written in Emacs Lisp as
        well as Python.
      '';
      license = gpl3Plus;
    };
  };

  evil-jumper = melpaBuild rec {
    pname   = "evil-jumper";
    version = "20151017";
    src = fetchFromGitHub {
      owner  = "bling";
      repo   = pname;
      rev    = "fcadf2d93aaea3ba88a2ae63a860b9c1f0568167";
      sha256 = "0axx6cc9z9c1wh7qgm6ya54dsp3bn82bnb0cwj1rpv509qqmwgsj";
    };
    packageRequires = [ evil ];
    meta = {
      description = "Jump across buffer boundaries and revive dead buffers if necessary";
      license = gpl3Plus;
    };
  };

  ess-R-object-popup =
    callPackage ../applications/editors/emacs-modes/ess-R-object-popup { };

  find-file-in-project = melpaBuild rec {
    pname = "find-file-in-project";
    version = "3.5";
    src = fetchFromGitHub {
      owner  = "technomancy";
      repo   = pname;
      rev    = "53a8d8174f915d9dcf5ac6954b1c0cae61266177";
      sha256 = "0wky8vqg08iw34prbz04bqmhfhj82y93swb8zkz6la2vf9da0gmd";
    };
    meta = {
      description = "Quick access to project files in Emacs";
      longDescription = ''
        Find files in a project quickly.
        This program provides a couple methods for quickly finding any file in a
        given project. It depends on GNU find.
      '';
      license = gpl3Plus;
    };
  };

  filesets-plus = callPackage ../applications/editors/emacs-modes/filesets-plus { };

  font-lock-plus = callPackage ../applications/editors/emacs-modes/font-lock-plus { };

  ghc-mod = melpaBuild rec {
    pname = "ghc";
    version = external.ghc-mod.version;
    src = external.ghc-mod.src;
    packageRequires = [ haskell-mode ];
    propagatedUserEnvPkgs = [ external.ghc-mod ];
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
    packageRequires = [];
    meta = {
      homepage = "https://melpa.org/#haskell-unicode-input-method/";
      license = lib.licenses.free;
    };
  };

  hexrgb = callPackage ../applications/editors/emacs-modes/hexrgb { };

  header2 = callPackage ../applications/editors/emacs-modes/header2 { };

  helm-words = callPackage ../applications/editors/emacs-modes/helm-words { };

  hindent = melpaBuild rec {
    pname = "hindent";
    version = external.hindent.version;
    src = external.hindent.src;
    packageRequires = [ haskell-mode ];
    propagatedUserEnvPkgs = [ external.hindent ];
    fileSpecs = [ "elisp/*.el" ];
    meta = {
      description = "Indent haskell code using the \"hindent\" program";
      license = bsd3;
    };
  };

  icicles = callPackage ../applications/editors/emacs-modes/icicles { };

  redshank = callPackage ../applications/editors/emacs-modes/redshank { };

  rtags = melpaBuild rec {
    pname = "rtags";
    version = "2.12";
    src = external.rtags.src;

    configurePhase = ":";

    propagatedUserEnvPkgs = [ external.rtags ];
    fileSpecs = [ "src/*.el" ];
    inherit (external.rtags) meta;
  };

  lcs = melpaBuild rec {
    pname   = "lcs";
    version = circe.version;
    src     = circe.src;
    fileSpecs = [ "lcs.el" ];
    meta = {
      description = "Longest Common Sequence (LCS) library for Emacs";
      license = gpl3Plus;
    };
  };

  lib-requires =
    callPackage ../applications/editors/emacs-modes/lib-requires { };

  lui = melpaBuild rec {
    pname   = "lui";
    version = circe.version;
    src     = circe.src;
    packageRequires = [ tracking ];
    fileSpecs = [ "lui*.el" ];
    meta = {
      description = "User interface library for Emacs";
      license = gpl3Plus;
    };
  };

  nyan-mode = callPackage ../applications/editors/emacs-modes/nyan-mode {
    inherit lib;
  };

  org-mac-link =
    callPackage ../applications/editors/emacs-modes/org-mac-link { };

  perl-completion =
    callPackage ../applications/editors/emacs-modes/perl-completion { };

  railgun = callPackage ../applications/editors/emacs-modes/railgun { };

  gn = callPackage ../applications/editors/emacs-modes/gn { };

  shorten = melpaBuild rec {
    pname   = "shorten";
    version = circe.version;
    src     = circe.src;
    fileSpecs = [ "shorten.el" ];
    meta = {
      description = "String shortening to unique prefix library for Emacs";
      license = gpl3Plus;
    };
  };

  stgit = callPackage ../applications/editors/emacs-modes/stgit { };

  structured-haskell-mode = melpaBuild rec {
    pname = "shm";
    version = external.structured-haskell-mode.version;
    src = external.structured-haskell-mode.src;
    packageRequires = [ haskell-mode ];
    fileSpecs = [ "elisp/*.el" ];
    propagatedUserEnvPkgs = [ external.structured-haskell-mode ];

    meta = {
      description = "Structured editing Emacs mode for Haskell";
      license = bsd3;
      platforms = external.structured-haskell-mode.meta.platforms;
    };
  };

  thingatpt-plus = callPackage ../applications/editors/emacs-modes/thingatpt-plus { };

  tramp = callPackage ../applications/editors/emacs-modes/tramp { };

  weechat = melpaBuild rec {
    pname   = "weechat.el";
    version = "0.2.2";
    src = fetchFromGitHub {
      owner  = "the-kenny";
      repo   = pname;
      rev    = version;
      sha256 = "0f90m2s40jish4wjwfpmbgw024r7n2l5b9q9wr6rd3vdcwks3mcl";
    };
    postPatch = lib.optionalString (!stdenv.isLinux) ''
      rm weechat-sauron.el weechat-secrets.el
    '';
    packageRequires = [ s ];
    meta = {
      description = "A weechat IRC client frontend for Emacs";
      license = gpl3Plus;
    };
  };

  yaoddmuse = callPackage ../applications/editors/emacs-modes/yaoddmuse { };

  zeitgeist = callPackage ../applications/editors/emacs-modes/zeitgeist { };

  };

in
  lib.makeScope newScope (self:
    {}
    // elpaPackages self
    // melpaStablePackages self
    // melpaPackages self
    // orgPackages self
    // packagesFun self
  )
