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

{ overrides

, lib, newScope, stdenv, fetchurl, fetchgit, fetchFromGitHub, fetchhg

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
    inherit lib;
  };

  emacsWithPackages = import ../build-support/emacs/wrapper.nix {
    inherit lib lndir makeWrapper stdenv;
  };

  packagesFun = self: with self; {

  inherit emacs melpaBuild trivialBuild;

  emacsWithPackages = emacsWithPackages self;

  ## START HERE

  pdf-tools = melpaBuild rec {
    pname = "pdf-tools";
    version = "0.70";
    src = fetchFromGitHub {
      owner = "politza";
      repo = "pdf-tools";
      rev = "v${version}";
      sha256 = "19sy49r3ijh36m7hl4vspw5c4i8pnfqdn4ldm2sqchxigkw56ayl";
    };
    buildInputs = with external; [ autoconf automake libpng zlib poppler pkgconfig ];
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

  apel = melpaBuild rec {
    pname = "apel";
    version = "10.8";
    src = fetchFromGitHub {
      owner  = "wanderlust";
      repo   = pname;
      rev    = "8402e59eadb580f59969114557b331b4d9364f95";
      sha256 = "0sdxnf4b8rqs1cbjxh23wvxmj7ll3zddv8yfdgif6zmgyy8xhc9m";
    };
    files = [
      "alist.el" "apel-ver.el" "broken.el" "calist.el"
      "emu.el" "filename.el" "install.el" "inv-23.el" "invisible.el"
      "mcharset.el" "mcs-20.el" "mcs-e20.el" "mule-caesar.el"
      "path-util.el" "pccl-20.el" "pccl.el" "pces-20.el" "pces-e20.el"
      "pces.el" "pcustom.el" "poe.el" "poem-e20.el" "poem-e20_3.el"
      "poem.el" "product.el" "pym.el" "richtext.el" "static.el"
    ];
    meta = {
      description = "A Portable Emacs Library";
      license = gpl3Plus; # probably
    };
  };

  caml = melpaBuild rec {
    pname   = "caml";
    version = "4.2.1"; # TODO: emacs doesn't seem to like 02 as a version component..
    src = fetchFromGitHub {
      owner  = "ocaml";
      repo   = "ocaml";
      rev    = "4.02.1";
      sha256 = "05lms9qhcnwgi7k034kiiic58c9da22r32mpak0ahmvp5fylvjpb";
    };
    fileSpecs = [ "emacs/*.el" ];
    configurePhase = "true";
    meta = {
      description = "OCaml code editing commands for Emacs";
      license = gpl2Plus;
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

  evil-indent-textobject = melpaBuild rec {
    pname   = "evil-indent-textobject";
    version = "0.2";
    src = fetchFromGitHub {
      owner  = "cofi";
      repo   = pname;
      rev    = "70a1154a531b7cfdbb9a31d6922482791e20a3a7";
      sha256 = "0nghisnc49ivh56mddfdlcbqv3y2vqzjvkpgwv3zp80ga6ghvdmz";
    };
    packageRequires = [ evil ];
    meta = {
      description = "Textobject for evil based on indentation";
      license = gpl2Plus;
    };
  };

  evil-visualstar = melpaBuild rec {
    pname   = "evil-visualstar";
    version = "20151017";
    src = fetchFromGitHub {
      owner  = "bling";
      repo   = pname;
      rev    = "bd9e1b50c03b37c57355d387f291c2ec8ce51eec";
      sha256 = "17m4kdz1is4ipnyiv9n3vss49faswbbd6v57df9npzsbn5jyydd0";
    };
    packageRequires = [ evil ];
    meta = {
      description = "Start a * or # search from the visual selection";
      license = gpl3Plus;
    };
  };

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

  gnus = melpaBuild rec {
    pname   = "gnus";
    version = "20140501";
    src = fetchgit {
      url = "http://git.gnus.org/gnus.git";
      rev = "4228cffcb7afb77cf39678e4a8988a57753502a5";
      sha256 = "0qd0wpxkz47irxghmdpa524c9626164p8vgqs26wlpbdwyvm64a0";
    };
    fileSpecs = [ "lisp/*.el" "texi/*.texi" ];
    preBuild = ''
      (cd lisp && make gnus-load.el)
    '';
    meta = {
      description = "News and mail reader for Emacs";
      license = gpl3Plus;
    };
  };

  goto-chg = melpaBuild rec {
    pname   = "goto-chg";
    version = "1.6";
    src = fetchhg {
      url = "https://bitbucket.org/lyro/evil";
      rev = "e5588e50c0e40a66c099868ea825755e348311fb";
      sha256 = "0185vrzfdz6iwhmc22rjy0n7ppfppp2ddc8xl0vvbda79q6w3bp8";
    };
    files = [ "lib/goto-chg.el" ];
    meta = {
      description = "Goto last change in current buffer using Emacs undo information";
      license = gpl3Plus;
    };
  };

  moe-theme = melpaBuild rec {
    pname   = "moe-theme";
    version = "1.0";
    src = fetchFromGitHub {
      owner  = "kuanyui";
      repo   = "${pname}.el";
      rev    = "39384a7a9e6886f3a3d79efac4009fcd800a4a14";
      sha256 = "0i7m15x9sij5wh0gwbijsis8a4jm8izywj7xprk21644ndskvfiz";
    };
    meta = {
      description = "A set of Emacs themes optimized for terminals with 256 colors";
      license = gpl3Plus;
    };
  };

  nyan-mode = callPackage ../applications/editors/emacs-modes/nyan-mode {
    inherit lib;
  };

  org-plus-contrib = elpaBuild rec {
    pname   = "org-plus-contrib";
    version = "20150406";
    src = fetchurl {
      url    = "http://orgmode.org/elpa/${pname}-${version}.tar";
      sha256 = "1ny2myg4rm75ab2gl5rqrwy7h53q0vv18df8gk3zv13kljj76c6i";
    };
    meta = {
      description = "Notes, TODO lists, projects, and authoring in plain-text with Emacs";
      license = gpl3Plus;
    };
  };

  helm-projectile = melpaBuild rec {
    pname   = "helm-projectile";
    version = projectile.version;
    src     = projectile.src;
    fileSpecs = [ "helm-projectile.el" ];
    packageRequires = [ helm projectile ];
    meta = projectile.meta;
  };
  persp-projectile = melpaBuild rec {
    pname   = "persp-projectile";
    version = projectile.version;
    src     = projectile.src;
    fileSpecs = [ "persp-projectile.el" ];
    packageRequires = [ perspective projectile ];
    meta = projectile.meta;
  };

  semi = melpaBuild rec {
    pname = "semi";
    version = "1.14.7"; # 20150203
    src = fetchFromGitHub {
      owner  = "wanderlust";
      repo   = pname;
      rev    = "9976269556c5bcc021e4edf1b0e1accd39929528";
      sha256 = "1g1xg57pz4msd3f998af5gq28qhmvi410faygzspra6y6ygaka68";
    };
    packageRequires = [ apel flim ];
    meta = {
      description = "MIME library for Emacs";
      license = gpl3Plus; # probably
    };
  };

  structured-haskell-mode = melpaBuild rec {
    pname = "shm";
    version = external.structured-haskell-mode.version;
    src = external.structured-haskell-mode.src;
    packageRequires = [ haskell-mode ];
    fileSpecs = [ "elisp/*.el" ];

    meta = {
      description = "Structured editing Emacs mode for Haskell";
      license = bsd3;
      platforms = external.structured-haskell-mode.meta.platforms;
    };
  };

  wanderlust = melpaBuild rec {
    pname = "wanderlust";
    version = "2.15.9"; # 20150301
    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = "13fb4f6519490d4ac7138f3bcf76707654348071";
      sha256 = "1l48xfcwkm205prspa1rns6lqfizik5gpdwmlfgyb5mabm9x53zn";
    };
    packageRequires = [ apel flim semi ];
    fileSpecs = [
      "doc/wl.texi" "doc/wl-ja.texi"
      "elmo/*.el" "wl/*.el"
      "etc/icons"
    ];
    meta = {
      description = "E-Mail client for Emacs";
      license = gpl3Plus; # probably
    };
  };

  };

in
  lib.makeScope newScope (self:
    {}
    // melpaPackages self
    // elpaPackages self
    // melpaStablePackages self
    // packagesFun self
  )
