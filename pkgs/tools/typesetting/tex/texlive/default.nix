/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscript_headless, harfbuzz
<<<<<<< HEAD
, makeWrapper, installShellFiles
, python3, ruby, perl, tk, jdk, bash, snobol4
, coreutils, findutils, gawk, getopt, gnugrep, gnumake, gnupg, gnused, gzip, ncurses, zip
, libfaketime, asymptote, biber-ms, makeFontsConf
=======
, makeWrapper, python3, ruby, perl, gnused, gnugrep, coreutils
, libfaketime, makeFontsConf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, useFixedHashes ? true
, recurseIntoAttrs
}:
let
  # various binaries (compiled)
  bin = callPackage ./bin.nix {
    ghostscript = ghostscript_headless;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
<<<<<<< HEAD
    inherit useFixedHashes;
    tlpdb = overriddenTlpdb;
  };

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin buildEnv lib makeWrapper writeText runCommand
      perl libfaketime makeFontsConf bash tl coreutils gawk gnugrep gnused;
=======
  };

  # map: name -> fixed-output hash
  fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixedHashes.nix);

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin combinePkgs buildEnv lib makeWrapper writeText
      stdenv python3 ruby perl gnused gnugrep coreutils libfaketime makeFontsConf;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ghostscript = ghostscript_headless;
  };

  tlpdb = import ./tlpdb.nix;

  tlpdbVersion = tlpdb."00texlive.config";

  # the set of TeX Live packages, collections, and schemes; using upstream naming
<<<<<<< HEAD
  overriddenTlpdb = let
    overrides = import ./tlpdb-overrides.nix {
      inherit
        stdenv lib bin tlpdb tlpdbxz tl
        installShellFiles
        coreutils findutils gawk getopt ghostscript_headless gnugrep
        gnumake gnupg gnused gzip ncurses perl python3 ruby zip;
    };
  in overrides tlpdb;
=======
  tl = let
    orig = removeAttrs tlpdb [ "00texlive.config" ];

    overridden = orig // {
      # overrides of texlive.tlpdb

      texlive-msg-translations = orig.texlive-msg-translations // {
        hasRunfiles = false; # only *.po for tlmgr
      };

      xdvi = orig.xdvi // { # it seems to need it to transform fonts
        deps = (orig.xdvi.deps or []) ++  [ "metafont" ];
      };

      # remove dependency-heavy packages from the basic collections
      collection-basic = orig.collection-basic // {
        deps = lib.filter (n: n != "metafont" && n != "xdvi") orig.collection-basic.deps;
      };
      # add them elsewhere so that collections cover all packages
      collection-metapost = orig.collection-metapost // {
        deps = orig.collection-metapost.deps ++ [ "metafont" ];
      };
      collection-plaingeneric = orig.collection-plaingeneric // {
        deps = orig.collection-plaingeneric.deps ++ [ "xdvi" ];
      };

      texdoc = orig.texdoc // {
        version = orig.texdoc.version + "-tlpdb-" + (toString tlpdbVersion.revision);

        # build Data.tlpdb.lua (part of the 'tlType == "run"' package)
        postUnpack = ''
          if [[ -f "$out"/scripts/texdoc/texdoc.tlu ]]; then
            unxz --stdout "${tlpdbxz}" > texlive.tlpdb

            # create dummy doc file to ensure that texdoc does not return an error
            mkdir -p support/texdoc
            touch support/texdoc/NEWS

            TEXMFCNF="${bin.core}"/share/texmf-dist/web2c TEXMF="$out" TEXDOCS=. TEXMFVAR=. \
              "${bin.luatex}"/bin/texlua "$out"/scripts/texdoc/texdoc.tlu \
              -c texlive_tlpdb=texlive.tlpdb -lM texdoc

            cp texdoc/cache-tlpdb.lua "$out"/scripts/texdoc/Data.tlpdb.lua
          fi
        '';
      };
    }; # overrides

    in lib.mapAttrs mkTLPkg overridden;
    # TODO: texlive.infra for web2c config?


  # create a TeX package: an attribute set { pkgs = [ ... ]; ... } where pkgs is a list of derivations
  mkTLPkg = pname: attrs:
    let
      version = attrs.version or (toString attrs.revision);
      mkPkgV = tlType: let
        pkg = attrs // {
          sha512 = attrs.sha512.${tlType};
          inherit pname tlType version;
        };
        in mkPkg pkg;
    in {
      # TL pkg contains lists of packages: runtime files, docs, sources, binaries
      pkgs =
        # tarball of a collection/scheme itself only contains a tlobj file
        [( if (attrs.hasRunfiles or false) then mkPkgV "run"
            # the fake derivations are used for filtering of hyphenation patterns and formats
          else {
            inherit pname version;
            tlType = "run";
            hasFormats = attrs.hasFormats or false;
            hasHyphens = attrs.hasHyphens or false;
            tlDeps = map (n: tl.${n}) (attrs.deps or []);
          }
        )]
        ++ lib.optional (attrs.sha512 ? doc) (mkPkgV "doc")
        ++ lib.optional (attrs.sha512 ? source) (mkPkgV "source")
        ++ lib.optional (bin ? ${pname})
            ( bin.${pname} // { tlType = "bin"; } );
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  version = {
    # day of the snapshot being taken
    year = "2023";
    month = "03";
    day = "19";
    # TeX Live version
    texliveYear = 2022;
    # final (historic) release or snapshot
    final = true;
  };

  # The tarballs on CTAN mirrors for the current release are constantly
  # receiving updates, so we can't use those directly. Stable snapshots
  # need to be used instead. Ideally, for the release branches of NixOS we
  # should be switching to the tlnet-final versions
  # (https://tug.org/historic/).
<<<<<<< HEAD
  mirrors = with version; lib.optionals final  [
=======
  urlPrefixes = with version; lib.optionals final  [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # tlnet-final snapshot; used when texlive.tlpdb is frozen
    # the TeX Live yearly freeze typically happens in mid-March
    "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${toString texliveYear}/tlnet-final"
    "ftp://tug.org/texlive/historic/${toString texliveYear}/tlnet-final"
  ] ++ [
    # daily snapshots hosted by one of the texlive release managers;
    # used for non-final snapshots and as fallback for final snapshots that have not reached yet the historic mirrors
    # please note that this server is not meant for large scale deployment and should be avoided on release branches
    # https://tug.org/pipermail/tex-live/2019-November/044456.html
    "https://texlive.info/tlnet-archive/${year}/${month}/${day}/tlnet"
  ];

  tlpdbxz = fetchurl {
<<<<<<< HEAD
    urls = map (up: "${up}/tlpkg/texlive.tlpdb.xz") mirrors;
=======
    urls = map (up: "${up}/tlpkg/texlive.tlpdb.xz") urlPrefixes;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-vm7DmkH/h183pN+qt1p1wZ6peT2TcMk/ae0nCXsCoMw=";
  };

  tlpdbNix = runCommand "tlpdb.nix" {
    inherit tlpdbxz;
    tl2nix = ./tl2nix.sed;
  }
  ''
    xzcat "$tlpdbxz" | sed -rn -f "$tl2nix" | uniq > "$out"
  '';

<<<<<<< HEAD
  # map: name -> fixed-output hash
  fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixed-hashes.nix);

  buildTeXLivePackage = import ./build-texlive-package.nix {
    inherit lib fetchurl runCommand bash jdk perl python3 ruby snobol4 tk;
    texliveBinaries = bin;
  };

  tl = lib.mapAttrs (pname: { revision, extraRevision ? "", ... }@args:
    buildTeXLivePackage (args
      # NOTE: the fixed naming scheme must match generate-fixed-hashes.nix
      // { inherit mirrors pname; fixedHashes = fixedHashes."${pname}-${toString revision}${extraRevision}" or { }; }
      // lib.optionalAttrs (args ? deps) { deps = map (n: tl.${n}) (args.deps or [ ]); })
  ) overriddenTlpdb;

  assertions = with lib;
    assertMsg (tlpdbVersion.year == version.texliveYear) "TeX Live year in texlive does not match tlpdb.nix, refusing to evaluate" &&
    assertMsg (tlpdbVersion.frozen == version.final) "TeX Live final status in texlive does not match tlpdb.nix, refusing to evaluate";
=======
  # create a derivation that contains an unpacked upstream TL package
  mkPkg = { pname, tlType, revision, version, sha512, postUnpack ? "", stripPrefix ? 1, ... }@args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + lib.optionalString (tlType != "run") ".${tlType}";
      tlName = urlName + "-${version}";
      fixedHash = fixedHashes.${tlName} or null; # be graceful about missing hashes

      urls = args.urls or (if args ? url then [ args.url ] else
        map (up: "${up}/archive/${urlName}.r${toString revision}.tar.xz") (args.urlPrefixes or urlPrefixes));

    in runCommand "texlive-${tlName}"
      ( {
          src = fetchurl { inherit urls sha512; };
          inherit stripPrefix;
          # metadata for texlive.combine
          passthru = {
            inherit pname tlType version;
          } // lib.optionalAttrs (tlType == "run" && args ? deps) {
            tlDeps = map (n: tl.${n}) args.deps;
          } // lib.optionalAttrs (tlType == "run") {
            hasFormats = args.hasFormats or false;
            hasHyphens = args.hasHyphens or false;
          };
        } // lib.optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        }
      )
      ( ''
          mkdir "$out"
          tar -xf "$src" \
          --strip-components="$stripPrefix" \
          -C "$out" --anchored --exclude=tlpkg --keep-old-files
        '' + postUnpack
      );

  # combine a set of TL packages into a single TL meta-package
  combinePkgs = pkgList: lib.catAttrs "pkg" (
    let
      # a TeX package is an attribute set { pkgs = [ ... ]; ... } where pkgs is a list of derivations
      # the derivations make up the TeX package and optionally (for backward compatibility) its dependencies
      tlPkgToSets = { pkgs, ... }: map ({ tlType, version ? "", outputName ? "", ... }@pkg: {
          # outputName required to distinguish among bin.core-big outputs
          key = "${pkg.pname or pkg.name}.${tlType}-${version}-${outputName}";
          inherit pkg;
        }) pkgs;
      pkgListToSets = lib.concatMap tlPkgToSets; in
    builtins.genericClosure {
      startSet = pkgListToSets pkgList;
      operator = { pkg, ... }: pkgListToSets (pkg.tlDeps or []);
    });

  assertions =
    lib.assertMsg (tlpdbVersion.year == version.texliveYear) "TeX Live year in texlive does not match tlpdb.nix, refusing to evaluate" &&
    lib.assertMsg (tlpdbVersion.frozen == version.final) "TeX Live final status in texlive does not match tlpdb.nix, refusing to evaluate";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in
  tl // {

    tlpdb = {
      # nested in an attribute set to prevent them from appearing in search
      nix = tlpdbNix;
      xz = tlpdbxz;
    };

<<<<<<< HEAD
    bin = assert assertions; bin // {
      # for backward compatibility
      latexindent = lib.findFirst (p: p.tlType == "bin") tl.latexindent.pkgs;
    };

=======
    bin = assert assertions; bin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    combine = assert assertions; combine;

    # Pre-defined combined packages for TeX Live schemes,
    # to make nix-env usage more comfortable and build selected on Hydra.
<<<<<<< HEAD
    combined = with lib;
      let
        # these license lists should be the sorted union of the licenses of the packages the schemes contain.
        # The correctness of this collation is tested by tests.texlive.licenses
        licenses = with lib.licenses; {
          scheme-basic = [ free gfl gpl1Only gpl2 gpl2Plus knuth lgpl21 lppl1 lppl13c mit ofl publicDomain ];
          scheme-context = [ bsd2 bsd3 cc-by-sa-40 free gfl gfsl gpl1Only gpl2 gpl2Plus gpl3 gpl3Plus knuth lgpl2 lgpl21
            lppl1 lppl13c mit ofl publicDomain x11 ];
          scheme-full = [ artistic1-cl8 artistic2 asl20 bsd2 bsd3 bsdOriginal cc-by-10 cc-by-40 cc-by-sa-10 cc-by-sa-20
            cc-by-sa-30 cc-by-sa-40 cc0 fdl13Only free gfl gfsl gpl1Only gpl2 gpl2Plus gpl3 gpl3Plus isc knuth
            lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
          scheme-gust = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-40 cc-by-sa-40 cc0 fdl13Only free gfl gfsl gpl1Only gpl2
            gpl2Plus gpl3 gpl3Plus knuth lgpl2 lgpl21 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
          scheme-infraonly = [ gpl2 gpl2Plus lgpl21 ];
          scheme-medium = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-40 cc-by-sa-20 cc-by-sa-30 cc-by-sa-40 cc0 fdl13Only
            free gfl gpl1Only gpl2 gpl2Plus gpl3 gpl3Plus isc knuth lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a lppl13c mit ofl
            publicDomain x11 ];
          scheme-minimal = [ free gpl1Only gpl2 gpl2Plus knuth lgpl21 lppl1 lppl13c mit ofl publicDomain ];
          scheme-small = [ asl20 cc-by-40 cc-by-sa-40 cc0 fdl13Only free gfl gpl1Only gpl2 gpl2Plus gpl3 gpl3Plus knuth
            lgpl2 lgpl21 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
          scheme-tetex = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-40 cc-by-sa-10 cc-by-sa-20 cc-by-sa-30 cc-by-sa-40 cc0
            fdl13Only free gfl gpl1Only gpl2 gpl2Plus gpl3 gpl3Plus isc knuth lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a
            lppl13c mit ofl publicDomain x11];
        };
      in recurseIntoAttrs (
=======
    combined = with lib; recurseIntoAttrs (
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      mapAttrs
        (pname: attrs:
          addMetaAttrs rec {
            description = "TeX Live environment for ${pname}";
            platforms = lib.platforms.all;
            maintainers = with lib.maintainers;  [ veprbl ];
<<<<<<< HEAD
            license = licenses.${pname};
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          }
          (combine {
            ${pname} = attrs;
            extraName = "combined" + lib.removePrefix "scheme" pname;
            extraVersion = with version; if final then "-final" else ".${year}${month}${day}";
          })
        )
        { inherit (tl)
            scheme-basic scheme-context scheme-full scheme-gust scheme-infraonly
            scheme-medium scheme-minimal scheme-small scheme-tetex;
        }
    );
  }
