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

, lib, newScope, stdenv, fetchurl, fetchgit, fetchFromGitHub, fetchhg, runCommand

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

  tablist = melpaBuild rec {
    pname = "tablist";
    inherit (pdf-tools) src version;
    fileSpecs = [ "lisp/tablist.el" "lisp/tablist-filter.el" ];
    meta = {
      description = "Extended tabulated-list-mode";
      license = gpl3;
    };
  };

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

  emacs-source-directory = stdenv.mkDerivation {
    name = "emacs-source-directory-1.0.0";
    src = emacs.src;

    # We don't want accidentally start bulding emacs one more time
    phases = "unpackPhase buildPhase";

    buildPhase = ''
     mkdir -p $out/share/emacs/site-lisp/elpa/emacs-source-directory
     cp -a src $out/src
     (cd $out/src && ${emacs}/bin/etags *.c *.h)
     cat <<EOF > $out/share/emacs/site-lisp/elpa/emacs-source-directory/emacs-source-directory-autoloads.el
     (setq source-directory "$out")
     (setq find-function-C-source-directory (expand-file-name "src" source-directory))
     EOF
     cat <<EOF > $out/share/emacs/site-lisp/elpa/emacs-source-directory/emacs-source-directory-pkg.el
     (define-package "emacs-source-directory" "1.0.0" "Make emacs C source code available inside emacs. To use with emacsWithPackages in NixOS" '())
     EOF
    '';
    meta = {
      description = "Make emacs C source code available inside emacs. To use with emacsWithPackages in NixOS";
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

  rtags = melpaBuild rec {
    pname = "rtags";
    version = "2.0"; # really, it's some arbitrary git hash
    src = external.rtags.src;
    propagatedUserEnvPkgs = [ external.rtags ];
    fileSpecs = [ "src/*.el" ];
    inherit (external.rtags) meta;
  };

  ido-ubiquitous = melpaBuild rec {
    pname   = "ido-ubiquitous";
    version = "2.17";
    src = fetchFromGitHub {
      owner  = "DarwinAwardWinner";
      repo   = pname;
      rev    = "323e4cddc05d5a4546c1b64132b2b1e9f8896452";
      sha256 = "0wdjz3cqzrxhrk68g5gyvc9j2rb6f4yw00xbjgw9ldwlhmkwy5ja";
    };
    meta = {
      description = "Does what you expected ido-everywhere should do in Emacs";
      license = gpl3Plus;
    };
  };

  idris-mode = melpaBuild rec {
    pname   = "idris-mode";
    version = "0.9.19";
    src = fetchFromGitHub {
      owner  = "idris-hackers";
      repo   = "idris-mode";
      rev    = version;
      sha256 = "0iwgbaq2797k1f7ql86i2pjfa67cha4s2v0mgmrd0qcgqkxsdq92";
    };
    packageRequires = [ prop-menu ];
    meta = {
      description = "Idris language support for Emacs";
      license = gpl3Plus;
    };
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

  log4e = melpaBuild rec {
    pname = "log4e";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "aki2o";
      repo  = pname;
      rev   = "v${version}";
      sha256 = "1l28n7a0v2zkknc70i1wn6qb5i21dkhfizzk8wcj28v44cgzk022";
    };
    meta = {
      description = "Logging for elisp";
      license = gpl2Plus;
    };
  };

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

  markdown-toc = melpaBuild rec {
    pname = "markdown-toc";
    version = "0.0.8";
    src = fetchFromGitHub {
      owner = "ardumont";
      repo = pname;
      rev = "06903e24457460a8964a978ace709c69afc36692";
      sha256 = "07w0w9g81c6c404l3j7gb420wc2kjmah728w84mdymscdl5w3qyl";
    };
    packageRequires = [ markdown-mode dash s ];
    files = [ "${pname}.el" ];
    meta = {
      description = "Generate a TOC in markdown file";
      longDescription = ''
        A simple mode to create TOC in a markdown file.
      '';
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

  monokai-theme = melpaBuild rec {
    pname   = "monokai-theme";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner  = "oneKelvinSmith";
      repo   = "monokai-emacs";
      rev    = "v${version}";
      sha256 = "02w7k4s4698p4adjy4a36na28sb1s2zw4xsjs7p2hv9iiw9kmyvz";
    };
    meta = {
      description = "An Emacs port of TextMate' Monokai theme inspired by Zenburn theme";
      license = gpl3Plus;
    };
  };

  multiple-cursors = melpaBuild rec {
    pname = "multiple-cursors";
    version = "20150627";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "multiple-cursors.el";
      rev    = "9b53e892e6167f930763a3c5aedf8773110a8ae9";
      sha256 = "0wcrdb137a9aq6dynlqbvypb6m2dj48m899xwy7ilnf2arrmipid";
    };
    meta = {
      description = "Edit text in many places simultaneously in Emacs";
      license = gpl3Plus; # TODO
    };
  };

  nyan-mode = callPackage ../applications/editors/emacs-modes/nyan-mode {
    inherit lib;
  };

  org2jekyll = melpaBuild rec {
    pname   = "org2jekyll";
    version = "0.1.8";
    src = fetchFromGitHub {
      owner = "ardumont";
      repo = pname;
      rev = "a12173b9507b3ef54dfebb5751503ba1ee93c6aa";
      sha256 = "064kw64w9snm0lbshxn8d6yd9xvyislhg37fmhq1w7vy8lm61xvf";
    };
    packageRequires = [ dash-functional s deferred ];
    files = [ "${pname}.el" ];
    meta = {
      description = "Blogging with org-mode and jekyll without alien yaml headers";
      license = gpl3Plus;
    };
  };

  org-trello = melpaBuild rec {
    pname = "org-trello";
    version = "0.7.5";
    src = fetchFromGitHub {
      owner = "org-trello";
      repo = pname;
      rev = "3718ed704094e5e5a491749f1f722d76ba4b7d73";
      sha256 = "1561nxjva8892via0l8315y3fih4r4q9gzycmvh33db8gqzq4l86";
    };
    packageRequires = [ request-deferred deferred dash-functional s ];
    files = [ "org-trello*.el" ];
    meta = {
      description = "Org minor mode - 2-way sync org & trello";
      longDescription = ''
        Org-trello is an emacs minor mode that extends org-mode with
        Trello abilities.
      '';
      homepage = https://org-trello.github.io/;
      license = gpl3Plus;
    };
  };

  parsebib = melpaBuild rec {
    pname = "parsebib";
    version = "20151006";
    src = fetchFromGitHub {
      owner = "joostkremers";
      repo = pname;
      rev = "9a1f60bed2814dfb5cec2b92efb5951a4b465cce";
      sha256 = "0n91whyjnrdhb9bqfif01ygmwv5biwpz2pvjv5w5y1d4g0k1x9ml";
    };
    meta = {
      description = "Emacs library for reading .bib files";
      license = bsd3;
    };
  };

  perspective = melpaBuild rec {
    pname   = "perspective";
    version = "1.12";
    src = fetchFromGitHub {
      owner  = "nex3";
      repo   = "${pname}-el";
      rev    = version;
      sha256 = "12c2rrhysrcl2arc6hpzv6lxbb1r3bzlvdp23hnp9sci6yc10k3q";
    };
    meta = {
      description = "Tagged workspaces like in most tiling window managers, but in Emacs";
      license = gpl3Plus;
    };
  };

  pkg-info = melpaBuild rec {
    pname   = "pkg-info";
    version = "20140610";
    src = fetchFromGitHub {
      owner  = "lunaryorn";
      repo   = "${pname}.el";
      rev    = "475cdeb0b8d44f9854e506c429eeb445787014ec";
      sha256 = "0x4nz54f2shgcw3gx66d265vxwdpdirn64gzii8dpxhsi7v86n0p";
    };
    packageRequires = [ epl ];
    meta = {
      description = "Provide information about Emacs packages";
      license = gpl3Plus;
    };
  };

  projectile = melpaBuild rec {
    pname   = "projectile";
    version = "0.13.0";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = pname;
      rev    = "v${version}";
      sha256 = "1rl6n6v9f4m7m969frx8b51a4lzfix2bxx6rfcfbh6kzhc00qnxf";
    };
    fileSpecs = [ "projectile.el" ];
    packageRequires = [ dash helm pkg-info ];
    meta = {
      description = "A project interaction library for Emacs";
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

  prop-menu = melpaBuild rec {
    pname   = "prop-menu";
    version = "0.1.2";
    src = fetchFromGitHub {
      owner  = "david-christiansen";
      repo   = "${pname}-el";
      rev    = version;
      sha256 = "18ap2liz5r5a8ja2zz9182fnfm47jnsbyblpq859zks356k37iwc";
    };
    meta = {
      description = "Library for computing context menus based on text properties and overlays in Emacs";
      license = gpl3Plus;
    };
  };

  pyvenv = melpaBuild rec {
    pname = "pyvenv";
    version = "1.7";
    src = fetchFromGitHub {
      owner  = "jorgenschaefer";
      repo   = pname;
      rev    = "e4f2fa7a32cf480f34d628d8eb5b9b60374d0e8e";
      sha256 = "1669id1p69kpq8zzldxj1p6iyz68701snn462g22k2acfzc2bfha";
    };
    meta = {
      description = "Python virtual environment interface for Emacs";
      longDescription = ''
        This is a simple global minor mode which will replicate the changes done
        by virtualenv activation inside Emacs.
      '';
      license = gpl2Plus;
    };
  };

  rainbow-delimiters = melpaBuild rec {
    pname = "rainbow-delimiters";
    version = "2.1.1";
    src = fetchFromGitHub {
      owner = "Fanael";
      repo = pname;
      rev = version;
      sha256 = "0gxc8j5a14bc9mp43cbcz41ipc0z1yvmypg52dnl8hadirry20gd";
    };
    meta = {
      description = "Highlight delimiters with colors according to their depth";
      license = gpl3Plus;
    };
  };

  request = melpaBuild rec {
    pname = "request";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "tkf";
      repo = "emacs-${pname}";
      rev = "adf7de452f9914406bfb693541f1d280093c4efd";
      sha256 = "0dja4g43zfjbxqvz2cgivgq5sfm6fz1563qgrp4yxknl7bdggb92";
    };

    files = [ "request.el" ];

    meta = {
      description = "Easy HTTP request for Emacs Lisp";
      longDescription = ''
        Request.el is a HTTP request library with multiple backends. It supports
        url.el which is shipped with Emacs and curl command line program. User
        can use curl when s/he has it, as curl is more reliable than url.el.
        Library author can use request.el to avoid imposing external dependencies
        such as curl to users while giving richer experience for users who have curl.
      '';
      license = gpl3Plus;
    };
  };

  request-deferred = melpaBuild rec {
    pname = "request-deferred";
    version = request.version;
    src = request.src;
    packageRequires = [ request deferred ];
    files = [ "request-deferred.el" ];
    meta = request.meta
        // { description = "${request.meta.description} (deferred)"; };
  };

  rich-minority = melpaBuild rec {
    pname   = "rich-minority";
    version = "0.1.1";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = pname;
      rev    = version;
      sha256 = "0kvhy4mgs9llihwsb1a9n5a85xzjiyiyawxnz0axy2bvwcxnp20k";
    };
    packageRequires = [ dash ];
    meta = {
      description = "Hiding and/or highlighting the list of minor modes in the Emacs mode-line";
      license = gpl3Plus;
    };
  };

  rust-mode = melpaBuild rec {
    pname = "rust-mode";
    version = "20151026";

    src = fetchFromGitHub {
      owner = "rust-lang";
      repo = pname;
      rev = "1761a9c212cdbc46cab5377c0ce90f96e33b2fbb";
      sha256 = "1wvjisi26lb4g5rjq80kq9jmf1r2m3isy47nwrnahfzxk886qfbq";
      };
    meta = {
      description = "A major mode for editing rust code";
      license = asl20;
    };
  };

  s = melpaBuild rec {
    pname   = "s";
    version = "20151023";
    src = fetchFromGitHub {
      owner  = "magnars";
      repo   = "${pname}.el";
      rev    = "372e94c1a28031686d75d6c52bfbe833a118a72a";
      sha256 = "1zn8n3mv0iscs242dbkf5vmkkizfslq5haw9z0d0g3wknq18286h";
    };
    meta = {
      description = "String manipulation library for Emacs";
      license = gpl3Plus;
    };
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

  smart-mode-line = melpaBuild rec {
    pname   = "smart-mode-line";
    version = "2.6";
    src = fetchFromGitHub {
      owner  = "Bruce-Connor";
      repo   = pname;
      rev    = version;
      sha256 = "17nav2jbvbd13xzgp29x396mc617n2dh6whjk4wnyvsyv7r0s9f6";
    };
    packageRequires = [ dash rich-minority ];
    meta = {
      description = "Sexy mode-line for Emacs";
      license = gpl3Plus;
    };
  };

  smartparens = melpaBuild rec {
    pname   = "smartparens";
    version = "20151025";
    src = fetchFromGitHub {
      owner  = "Fuco1";
      repo   = pname;
      rev    = "85583f9570be58f17ccd68388d9d4e58234d8ae9";
      sha256 = "1pvzcrnzvksx1rzrr19256x1qhidr2acz6yipijlfx2zfjx2gxa7";
    };
    packageRequires = [ dash ];
    meta = {
      description = "Minor mode for Emacs that deals with parens pairs";
      longDescription = ''
        It started as a unification effort to combine functionality of
        several existing packages in a single, compatible and
        extensible way to deal with parentheses, delimiters, tags and
        the like. Some of these packages include autopair, textmate,
        wrap-region, electric-pair-mode, paredit and others.
      '';
      license = gpl3Plus;
    };
  };

  smex = melpaBuild rec {
    pname = "smex";
    version = "20141210";
    src = fetchFromGitHub {
      owner  = "nonsequitur";
      repo   = pname;
      rev    = "aff8d4485139ac28f1c7e62912c0d0d480995831";
      sha256 = "0017f1ji7rxad2n49dhn5g0pmw6lmw80cqk6dynszizj46xpbqfp";
    };
    meta = {
      description = "M-x enhancement for Emacs build on top of Ido";
      license = emacs.meta.license; # should be "same as Emacs"
    };
  };

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

  swiper = melpaBuild rec {
    pname   = "swiper";
    version = "0.7.0";
    src = fetchFromGitHub {
      owner  = "abo-abo";
      repo   = pname;
      rev    = version;
      sha256 = "1kahl3h18vsjkbqvd84fb2w45s4srsiydn6jiv49vvg1yaxzxcbm";
    };
    fileSpecs = [ "swiper.el" "ivy.el" "colir.el" "counsel.el" ];
    meta = {
      description = "Overview as you search for a regex in Emacs";
      license = gpl3Plus;
    };
  };
  ivy = swiper;

  #TODO: swiper-helm

  switch-window = melpaBuild rec {
    pname   = "switch-window";
    version = "20140919";
    src = fetchFromGitHub {
      owner  = "dimitri";
      repo   = pname;
      rev    = "3ffbe68e584f811e891f96afa1de15e0d9c1ebb5";
      sha256 = "09221128a0f55a575ed9addb3a435cfe01ab6bdd0cca5d589ccd37de61ceccbd";
    };
    meta = {
      description = "Visual replacement for C-x o in Emacs";
      license = gpl3Plus;
    };
  };

  tramp = callPackage ../applications/editors/emacs-modes/tramp { };

  tracking = melpaBuild rec {
    pname   = "tracking";
    version = circe.version;
    src     = circe.src;
    packageRequires = [ shorten ];
    fileSpecs = [ "tracking.el" ];
    meta = {
      description = "Register buffers for user review library for Emacs";
      license = gpl3Plus;
    };
  };

  tuareg = melpaBuild rec {
    pname = "tuareg";
    version = "2.0.9";
    src = fetchFromGitHub {
      owner  = "ocaml";
      repo   = pname;
      rev    = version;
      sha256 = "0jpcjy2a77mywba2vm61knj26pgylsmv5a21cdp80q40bac4i6bb";
    };
    packageRequires = [ caml ];
    meta = {
      description = "Extension of OCaml mode for Emacs";
      license = gpl3Plus;
    };
  };

  use-package = melpaBuild rec {
    pname   = "use-package";
    version = "20151112";
    src = fetchFromGitHub {
      owner  = "jwiegley";
      repo   = pname;
      rev    = "77a77c8b03044f0279e00cadd6a6d1a7ae97b01";
      sha256 = "14v6wzqn2jhjdbr7nwqilxy9l79m1f2rdrz2c6c6pcla5yjpd1k0";
    };
    packageRequires = [ bind-key diminish ];
    files = [ "use-package.el" ];
    meta = {
      description = "Isolate package configuration in your .emacs file";
      license = gpl3Plus;
    };
  };

  volatile-highlights = melpaBuild rec {
    pname   = "volatile-highlights";
    version = "1.11";
    src = fetchFromGitHub {
      owner  = "k-talo";
      repo   = "${pname}.el";
      rev    = "fb2abc2d4d4051a9a6b7c8de2fe7564161f01f24";
      sha256 = "1v0chqj5jir4685jd8ahw86g9zdmi6xd05wmzhyw20rbk924fcqf";
    };
    meta = {
      description = "Brings visual feedback to some operations in Emacs";
      license = gpl3Plus;
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

  web-mode = melpaBuild rec {
    pname   = "web-mode";
    version = "11.1.12";
    src = fetchFromGitHub {
      owner  = "fxbois";
      repo   = pname;
      rev    = "67259f16bfaec5c006a53533b8feeba7771e1365";
      sha256 = "16zcnwm7wnbl1xbsx7rr5rr697ax141akfx2lknwirx18vqmkijj";
    };

    meta = {
      description = "Web template editing mode for Emacs";
      license = gpl2;
    };
  };

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

  wgrep = melpaBuild rec {
    pname   = "wgrep";
    version = "20141017";
    src = fetchFromGitHub {
      owner  = "mhayashi1120";
      repo   = "Emacs-wgrep";
      rev    = "7ef26c51feaef8a5ec0929737130ab8ba326983c";
      sha256 = "075z0glain0dp56d0cp468y5y88wn82ab26aapsrdzq8hmlshwn4";
    };
    meta = {
      description = "Writable grep buffer mode for Emacs";
      license = gpl3Plus;
    };
  };

  zenburn-theme = melpaBuild rec {
    pname   = "zenburn-theme";
    version = "2.2";
    src = fetchFromGitHub {
      owner  = "bbatsov";
      repo   = "zenburn-emacs";
      rev    = "v${version}";
      sha256 = "1zspqpwgyv3969irg8p7zj3g4hww4bmnlvx33bvjyvvv5c4mg5wv";
    };
    meta = {
      description = "An Emacs port of Vim's low contrast Zerburn theme";
      license = gpl3Plus;
    };
  };

  };

in
  lib.makeScope newScope (self:
    {}
    // melpaPackages self
    // elpaPackages self
    // melpaStablePackages self
    // orgPackages self
    // packagesFun self
  )
