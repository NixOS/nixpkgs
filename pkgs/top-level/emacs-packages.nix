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
, stdenv, fetchurl, texinfo

}@args:

let
  self = super // defaultOverrides self super // overrides self super;

  super =
    { inherit emacs; }
    // lib.mapAttrs elpaPackage elpa
    // lib.mapAttrs (pname: pkg: melpaPackage pname pkg recipes."${pname}") packages;

  packages =
    lib.mapAttrs (n: p: p // { deps = if p.deps == null then p.deps else cleanUpDepsNames p.deps; })
    (cleanUpNames melpa.packages);

  recipes = cleanUpNames melpa.recipes;

  melpa = builtins.fromJSON (builtins.readFile ../build-support/emacs/melpa-unstable.json);
  elpa =
    lib.mapAttrs (n: p: p // {
      deps = if p.deps == null then [] else cleanUpDepsNames (builtins.attrNames p.deps);
    })
    (cleanUpNames (builtins.fromJSON (builtins.readFile ../build-support/emacs/elpa.json)));

  packageBuild = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/${melpa.rev}/package-build.el";
    inherit (melpa) sha256;
  };

  cleanUpNames = lib.mapAttrs' (name:
    lib.nameValuePair (lib.replaceChars ["@"] ["at"] name));

  cleanUpDepsNames = map (lib.replaceChars ["@"] ["at"]);

  callPackage = newScope { mkDerivation = melpaBuild; emacsPackages = self; };

  trivialBuild = callPackage ../build-support/emacs/trivial.nix {
    inherit emacs stdenv texinfo;
  };

  melpaBuild = callPackage ../build-support/emacs/melpa.nix {
    inherit emacs stdenv texinfo;
  };

  fromRecipe = callPackage ../build-support/emacs/from-recipe.nix {
    inherit emacs stdenv texinfo packageBuild;
  };

  builtin = "";

  melpaPackage = pname: pkg: rcp:
    let
      drv = { mkDerivation, fetchbzr, fetchcvs, fetchgit, fetchhg, fetchsvn, fetchurl
            , stdenv, emacsPackages }:
        mkDerivation rec {
          inherit pname;
          version = pkg.ver;

          recipe =
            let inherit (melpa) rev;
            in fetchurl {
              url = "https://raw.githubusercontent.com/milkypostman/melpa/${rev}/recipes/${pname}";
              inherit (rcp) sha256;
            };

          src =
            {
              git =
                fetchgit
                ({ inherit (rcp) url; inherit (pkg) rev sha256; }
                // (if rcp.branch == null then {} else { branchName = rcp.branch; }));
              github =
                let url = "http://github.com/${rcp.repo}.git";
                in fetchgit
                ({ inherit url; inherit (pkg) rev sha256; }
                // (if rcp.branch == null then {} else { branchName = rcp.branch; }));
              bzr =
                fetchbzr {
                  inherit (rcp) url;
                  inherit (pkg) rev sha256;
                };
              hg =
                fetchhg {
                  inherit (rcp) url;
                  inherit (pkg) rev sha256;
                };
              cvs =
                fetchcvs {
                  cvsRoot = rcp.url;
                  inherit (rcp) module;
                  inherit (pkg) sha256;
                };
              svn =
                fetchsvn {
                  inherit (rcp) url;
                  inherit (pkg) rev sha256;
                  name = "${pname}-${pkg.rev}";
                };
              wiki =
                let url = if rcp.url != null then rcp.url else
                      "http://www.emacswiki.org/emacs/download/${pname}.el";
                in fetchurl { inherit url; inherit (pkg) sha256; };
              fossil = throw "${pname}: unsupported fetcher 'fossil'";
              darcs = throw "${pname}: unsupported fetcher 'darcs'";
            }."${rcp.fetcher}"
            or (throw "${pname}: unknown fetcher '${rcp.fetcher}'");

          packageRequires =
            let lookupDep = dep:
                  emacsPackages."${dep}"
                  or (builtins.trace "${pname}: unknown dependency ${dep}" null);
            in map lookupDep pkg.deps;

          meta = {
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            license = stdenv.lib.licenses.free;
          };
        };
    in callPackage drv { mkDerivation = fromRecipe; };

  elpaPackage = pname: pkg:
    let
      ver = lib.concatStringsSep "." (map builtins.toString pkg.ver);
      drv = { mkDerivation, fetchurl, stdenv, emacsPackages }:
        mkDerivation rec {
          inherit pname;
          version = ver;

          src =
            let url =
                  {
                    "single" = "http://elpa.gnu.org/packages/${pname}-${ver}.el";
                    "tar" = "http://elpa.gnu.org/packages/${pname}-${ver}.tar";
                  }."${pkg.dist}" or (throw "${pname}: unknown distribution type '${pkg.dist}'");
            in fetchurl {
              inherit url;
              inherit (pkg) sha256;
            };

          packageRequires =
            let lookupDep = dep:
                  emacsPackages."${dep}"
                  or (builtins.trace "${pname}: unknown dependency ${dep}" null);
            in map lookupDep pkg.deps;

          meta = {
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            license = stdenv.lib.licenses.free;
          };
        };
    in callPackage drv { mkDerivation = melpaBuild; };

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

    cedet = callPackage ../applications/editors/emacs-modes/cedet { };

    cl = builtin;

    cl-lib = builtin;

    coffee = callPackage ../applications/editors/emacs-modes/coffee { };

    cryptol = super.cryptol-mode;

    cua = callPackage ../applications/editors/emacs-modes/cua { };

    d = super.d-mode;

    darcsum = callPackage ../applications/editors/emacs-modes/darcsum { };

    ede = builtin;

    eieio = builtin;

    emacs-clang-complete-async = callPackage ../applications/editors/emacs-modes/emacs-clang-complete-async { };

    emacs-session-management = callPackage ../applications/editors/emacs-modes/session-management-for-emacs { };

    erc = builtin;

    flymake = builtin;

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
      in callPackage drv { };

    gnus = builtin;

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

    htmlfontify = builtin;

    ido = builtin;

    jade = super.jade-mode;

    jdee = callPackage ../applications/editors/emacs-modes/jdee {
      inherit emacs;
      inherit (self) cedet;
    };

    json = builtin;

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

    ruby-mode = builtin;

    semantic = builtin;

    sql = builtin;

    stratego = callPackage ../applications/editors/emacs-modes/stratego { };

    structured-haskell-mode = super.shm;

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
      in callPackage drv { };

    timeclock = builtin;
  };

in self
