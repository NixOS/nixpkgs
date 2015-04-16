# package.el-based emacs packages
#
## add this at the start your init.el:
# (require 'package)
#
# ;; optional. makes unpure packages archives unavailable
# (setq package-archives nil)
#
# (add-to-list 'package-directory-list "/run/current-system/sw/share/emacs/site-lisp/elpa")
#
# ;; optional. use this if you install emacs packages to user profiles (with nix-env)
# (add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")
#
# (package-initialize)

{ emacs, overrides ? (self: super: {})

, pkgs, lib, newScope
, stdenv, texinfo

, path
}@args:

let
  self = super // defaultOverrides self super // overrides self super;

  super = { inherit emacs; } // lib.mapAttrs package json;

  json =
    lib.mapAttrs (n: p: p // { deps = if p.deps == null then p.deps else cleanUpNames p.deps; })
    (cleanUpNames (builtins.fromJSON (builtins.readFile path)));

  cleanUpNames = lib.mapAttrs' (name:
    lib.nameValuePair (lib.replaceChars ["@"] ["at"] name));

  callPackage = newScope { mkDerivation = melpaBuild; emacs-packages = self; };

  trivialBuild = callPackage ../build-support/emacs/trivial.nix {
    inherit emacs stdenv texinfo;
  };

  melpaBuild = callPackage ../build-support/emacs/melpa.nix {
    inherit emacs stdenv texinfo;
  };

  package = pname: pkg:
    let
      drv = { mkDerivation, fetchurl, stdenv, emacs-packages }:
        mkDerivation rec {
          inherit pname;
          version = lib.concatStringsSep "." (map toString pkg.ver);

          src =
            let filename ="${pname}-${version}.${ext}";
                ext =
                  if pkg.dist == "single" then "el"
                  else if pkg.dist == "tar" then "tar"
                  else throw "${pname}: unknown distribution type ${pkg.dist}";
                url = { url = "${pkg.archive}/${filename}"; };
                hash = if pkg.hash == null then {} else { sha256 = pkg.hash; };
            in fetchurl (url // hash);

          packageRequires =
            let depNames =
                  if pkg.deps == null then []
                  else builtins.attrNames pkg.deps;
                lookupDep = dep:
                  if lib.hasAttr dep emacs-packages
                  then lib.getAttr dep emacs-packages
                  else builtins.trace "${pname}: unknown dependency ${dep}" null;
            in map lookupDep depNames;

          meta = {
            description = pkg.desc;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            license = stdenv.lib.licenses.free;
            broken = if pkg.broken == null then false else pkg.broken;
          };
        };
    in callPackage drv {};

    defaultOverrides = self: super: {

      agda2-mode =
        let drv = { mkDerivation, Agda }:
              mkDerivation {
                pname = "agda-mode";
                version = Agda.version;
                phases = [ "buildPhase" "installPhase" ];
                # already byte-compiled by Agda builder
                buildPhase = ''
                  agda=$(${Agda}/bin/agda-mode locate)
                  cp $(dirname $agda)/*.el* . # */
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
        in callPackage drv {
          inherit (pkgs.haskellngPackages) Agda;
          mkDerivation = trivialBuild;
        };

      bbdb = callPackage ../applications/editors/emacs-modes/bbdb { };

      bbdb3 = callPackage ../applications/editors/emacs-modes/bbdb/3.nix {};

      cask = callPackage ../applications/editors/emacs-modes/cask { };

      cedet = callPackage ../applications/editors/emacs-modes/cedet { };

      coffee = callPackage ../applications/editors/emacs-modes/coffee { };

      cryptol = callPackage ../applications/editors/emacs-modes/cryptol { };

      cua = callPackage ../applications/editors/emacs-modes/cua { };

      d = callPackage ../applications/editors/emacs-modes/d { };

      darcsum = callPackage ../applications/editors/emacs-modes/darcsum { };

      emacs-clang-complete-async = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

      emacs-session-management = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

      emacs-w3m = callPackage ../applications/editors/emacs-modes/emacs-w3m { };

      emms = callPackage ../applications/editors/emacs-modes/emms { };

      ensime =
        let drv = { mkDerivation, fetchurl, emacs-packages, unzip }:
              mkDerivation {
                pname = "ensime";
                version = "20140904";
                src = fetchurl {
                  url = "https://github.com/ensime/ensime-emacs/archive/d3820a3f362975f6e14b817988ec07bfef2b4dad.zip";
                  sha256 = "0gwr0r92z2hh2x8g0hpxaar2vvfk1b91cp6v04gaasw0fvl5i7g5";
                };
                packageRequires = with emacs-packages;
                  [ auto-complete dash s scala-mode2 sbt-mode ];
                buildInputs = [ unzip ];
              };
        in callPackage drv {};

      ghc-mod =
        let drv = { mkDerivation, ghc-mod, stdenv }:
              mkDerivation rec {
                pname = "ghc";
                version = ghc-mod.version;
                src = ghc-mod.src;
                propagatedUserEnvPkgs = [ ghc-mod ];
                fileSpecs = [ "elisp/*.el" ];
                meta = { license = stdenv.lib.licenses.bsd3; };
              };
        in callPackage drv { inherit (pkgs.haskellngPackages) ghc-mod; };

      git-modes =
        let drv = { mkDerivation, stdenv, fetchFromGitHub }:
              mkDerivation {
                pname = "git-modes";
                version = "1.1.0";
                src = fetchFromGitHub {
                  owner = "magit";
                  repo = "git-modes";
                  rev = "1.1.0";
                  sha256 = "1vxarvprv990cf72d5sjmin51xp6pjc4ishxci33fbgn8ajc40dx";
                };
                meta = {
                  homepage = "https://github.com/magit/git-modes";
                  description = "Emacs modes for various Git-related files";
                  license = stdenv.lib.licenses.gpl3Plus;
                  maintainers = with stdenv.lib.maintainers; [ simons ];
                };
              };
        in callPackage drv {};

      goto-chg =
        let drv = { mkDerivation, fetchurl, stdenv }:
              mkDerivation {
                pname = "goto-chg";
                version = "1.6";
                src = fetchurl {
                  url = "http://www.emacswiki.org/emacs/download/goto-chg.el";
                  sha256 = "078d6p4br5vips7b9x4v6cy0wxf6m5ij9gpqd4g33bryn22gnpij";
                };
                meta = {
                  description = "Goto last change";
                  maintainers = with stdenv.lib.maintainers; [ ttuegel ];
                  license = stdenv.lib.licenses.gpl2Plus;
                };
              };
        in callPackage drv {};

      graphviz-dot-mode =
        let drv = { mkDerivation, fetchurl }:
              mkDerivation rec {
                pname = "graphviz-dot-mode";
                version = "0.3.3";
                src = fetchurl {
                  url = "http://www.graphviz.org/Misc/graphviz-dot-mode.el";
                  sha256 = "6465c18cfaa519a063cf664207613f70b0a17ac5eabcfaa949b3c4c289842953";
                };
                meta = {
                  homepage = "http://www.graphviz.org/";
                  description = "An emacs mode for the DOT Language, used by graphviz";
                };
              };
        in callPackage drv {};

      hol_light-mode = callPackage ../applications/editors/emacs-modes/hol_light { };

      hsc3-mode =
        let drv = { mkDerivation, hsc3, stdenv }:
              mkDerivation {
                pname = "hsc3-mode";
                version = hsc3.version;
                src = hsc3.src;
                phases = ["unpackPhase" "installPhase"];
                installPhase = ''
                  mkdir -p "$out/share/emacs/site-lisp"
                  cp "emacs/hsc3.el" "$out/share/emacs/site-lisp"
                '';
                meta = {
                  homepage = http://rd.slavepianos.org/?t=hsc3;
                  description = "hsc3 mode package for Emacs";
                  platforms = stdenv.lib.platforms.unix;
                };
                fileSpecs = [ "emacs/*.el" ];
              };
        in callPackage drv {
          inherit (pkgs.haskellngPackages) hsc3;
          mkDerivation = trivialBuild;
        };

      icicles = callPackage ../applications/editors/emacs-modes/icicles { };

      jade =
        let drv = { mkDerivation, fetchFromGitHub, emacs-packages, stdenv }:
              mkDerivation {
                pname = "jade-mode";
                version = "20120802";
                src = fetchFromGitHub {
                  owner = "brianc";
                  repo = "jade-mode";
                  rev = "275ab149edb0f6bcfae6ac17ba456f3351191604";
                  sha256 = "3cd2bebcd66e59d60b8e5e538e65a8ffdfc9a53b86443090a284e8329d7cb09b";
                };
                packageRequires = with emacs-packages; [ sws-mode ];
                meta = {
                  description = "Emacs major mode for jade and stylus";
                  homepage = https://github.com/brianc/jade-mode;
                  license = stdenv.lib.licenses.gpl2Plus;
                  platforms = stdenv.lib.platforms.all;
                };
              };
        in callPackage drv {};

      jdee = callPackage ../applications/editors/emacs-modes/jdee {
        inherit emacs;
        inherit (self) cedet;
      };

      maude-mode = callPackage ../applications/editors/emacs-modes/maude { };

      notmuch = pkgs.lowPrio (pkgs.notmuch.override { inherit emacs; });

      ocaml-mode = callPackage ../applications/editors/emacs-modes/ocaml { };

      org = pkgs.hiPrio super.org;

      prolog-mode = callPackage ../applications/editors/emacs-modes/prolog { };

      proofgeneral_4_2 = callPackage ../applications/editors/emacs-modes/proofgeneral/4.2.nix {
        texinfo = pkgs.texinfo4 ;
        texLive = pkgs.texLiveAggregationFun {
          paths = [ pkgs.texLive pkgs.texLiveCMSuper ];
        };
      };

      proofgeneral_4_3_pre = callPackage ../applications/editors/emacs-modes/proofgeneral/4.3pre.nix {
        texinfo = pkgs.texinfo4 ;
        texLive = pkgs.texLiveAggregationFun {
          paths = [ pkgs.texLive pkgs.texLiveCMSuper ];
        };
      };

      proofgeneral = self.proofgeneral_4_2;

      remember = callPackage ../applications/editors/emacs-modes/remember {
        inherit (self) bbdb;
      };

      sbt-mode =
        let drv = { mkDerivation, emacs-packages, unzip, fetchurl }:
              mkDerivation {
                pname = "sbt-mode";
                version = "20140605";
                src = fetchurl {
                  url = "https://github.com/hvesalai/sbt-mode/archive/676f22d9658989de401d299ed0250db9b911574d.zip";
                  sha256 = "0b8qrr3yp48ggl757d3a6bz633mbf4zxqpcwsh47b1ckiwa3nb2h";
                };
                packageRequires = with emacs-packages; [ scala-mode2 ];
                buildInputs = [ unzip ];
                meta = {
                  homepage = "https://github.com/hvesalai/scala-mode2";
                  description = "An Emacs mode for editing Scala code";
                  license = "permissive";
                };
              };
        in callPackage drv {};

      stratego = callPackage ../applications/editors/emacs-modes/stratego { };

      structured-haskell-mode =
        let drv = { mkDerivation, emacs-packages, structured-haskell-mode, stdenv }:
              melpaBuild rec {
                pname = "shm";
                version = structured-haskell-mode.version;
                src = structured-haskell-mode.src;
                packageRequires = with emacs-packages; [ haskell-mode ];
                fileSpecs = [ "elisp/*.el" ];

                meta = {
                  homepage = "https://github.com/chrisdone/structured-haskell-mode";
                  description = "Structured editing Emacs mode for Haskell";
                  license = stdenv.lib.licenses.bsd3;
                  platforms = structured-haskell-mode.meta.platforms;
                };
              };
        in callPackage drv {
          inherit (pkgs.haskellngPackages) structured-haskell-mode;
        };

      sunrise-commander =
        let drv = { mkDerivation, fetchFromGitHub, stdenv }:
              mkDerivation {
                pname = "sunrise-commander";
                version = "6.18.435";
                src = fetchFromGitHub {
                  owner = "escherdragon";
                  repo = "sunrise-commander";
                  rev = "7a44ca7abd9fe79f87934c78d00dc2a91419a4f1";
                  sha256 = "2909beccc9daaa79e70876ac6547088c2459b624c364dda1886fe4d7adc7708b";
                };
                meta = {
                  description = "Two-pane file manager for Emacs based on Dired and inspired by MC";
                  homepage = http://www.emacswiki.org/emacs/Sunrise_Commander;
                  license = stdenv.lib.licenses.gpl3Plus;

                  platforms = stdenv.lib.platforms.all;
                };
              };
        in callPackage drv {};
  };

in self
