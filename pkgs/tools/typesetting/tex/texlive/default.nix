/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscript_headless, harfbuzz
, makeWrapper, installShellFiles
, python3, ruby, perl, tk, jdk, bash, snobol4
, coreutils, findutils, gawk, getopt, gnugrep, gnumake, gnupg, gnused, gzip, ncurses, zip
, libfaketime, asymptote, biber-ms, makeFontsConf
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
    inherit useFixedHashes;
  };

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin buildEnv lib makeWrapper writeText runCommand
      perl libfaketime makeFontsConf bash tl coreutils gawk gnugrep gnused;
    ghostscript = ghostscript_headless;
  };

  tlpdb = import ./tlpdb.nix;

  tlpdbVersion = tlpdb."00texlive.config";

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  overriddenTlpdb = let
    overrides = import ./tlpdb-overrides.nix {
      inherit
        lib bin tlpdb tlpdbxz tl
        installShellFiles
        coreutils findutils gawk getopt ghostscript_headless gnugrep
        gnumake gnupg gnused gzip ncurses perl python3 ruby zip;
    };
  in overrides tlpdb;

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
  mirrors = with version; lib.optionals final  [
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
    urls = map (up: "${up}/tlpkg/texlive.tlpdb.xz") mirrors;
    hash = "sha256-vm7DmkH/h183pN+qt1p1wZ6peT2TcMk/ae0nCXsCoMw=";
  };

  tlpdbNix = runCommand "tlpdb.nix" {
    inherit tlpdbxz;
    tl2nix = ./tl2nix.sed;
  }
  ''
    xzcat "$tlpdbxz" | sed -rn -f "$tl2nix" | uniq > "$out"
  '';

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

in
  tl // {

    tlpdb = {
      # nested in an attribute set to prevent them from appearing in search
      nix = tlpdbNix;
      xz = tlpdbxz;
    };

    bin = assert assertions; bin // {
      # for backward compatibility
      latexindent = lib.findFirst (p: p.tlType == "bin") tl.latexindent.pkgs;
    };

    combine = assert assertions; combine;

    # Pre-defined combined packages for TeX Live schemes,
    # to make nix-env usage more comfortable and build selected on Hydra.
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
      mapAttrs
        (pname: attrs:
          addMetaAttrs rec {
            description = "TeX Live environment for ${pname}";
            platforms = lib.platforms.all;
            maintainers = with lib.maintainers;  [ veprbl ];
            license = licenses.${pname};
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
