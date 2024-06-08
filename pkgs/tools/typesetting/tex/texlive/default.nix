/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ lib
#, stdenv
, gcc12Stdenv
, fetchurl, runCommand, writeShellScript, writeText, buildEnv
, callPackage, ghostscript_headless, harfbuzz
, makeWrapper, installShellFiles
, python3, ruby, perl, tk, jdk, bash, snobol4
, coreutils, findutils, gawk, getopt, gnugrep, gnumake, gnupg, gnused, gzip, html-tidy, ncurses, zip
, libfaketime, asymptote, biber-ms, makeFontsConf
, useFixedHashes ? true
, recurseIntoAttrs
}:
let stdenv = gcc12Stdenv; in
let
  # various binaries (compiled)
  bin = callPackage ./bin.nix {
    ghostscript = ghostscript_headless;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
    inherit useFixedHashes;
    tlpdb = overriddenTlpdb;
  };

  tlpdb = import ./tlpdb.nix;

  tlpdbVersion = tlpdb."00texlive.config";

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  overriddenTlpdb = let
    overrides = import ./tlpdb-overrides.nix {
      inherit
        stdenv lib bin tlpdb tlpdbxz tl
        installShellFiles
        coreutils findutils gawk getopt ghostscript_headless gnugrep
        gnumake gnupg gnused gzip html-tidy ncurses perl python3 ruby zip;
    };
  in overrides tlpdb;

  version = {
    # day of the snapshot being taken
    year = "2024";
    month = "03";
    day = "16";
    # TeX Live version
    texliveYear = 2023;
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
    # CTAN mirrors
    "https://mirror.ctan.org/systems/texlive/tlnet"
    # daily snapshots hosted by one of the texlive release managers;
    # used for packages that in the meanwhile have been updated or removed from CTAN
    # and for packages that have not reached yet the historic mirrors
    # please note that this server is not meant for large scale deployment
    # https://tug.org/pipermail/tex-live/2019-November/044456.html
    # https://texlive.info/ MUST appear last (see tlpdbxz)
    "https://texlive.info/tlnet-archive/${year}/${month}/${day}/tlnet"
  ];

  tlpdbxz = fetchurl {
    urls = map (up: "${up}/tlpkg/texlive.tlpdb.xz")
      # use last mirror for daily snapshots as texlive.tlpdb.xz changes every day
      # TODO make this less hacky
      (if version.final then mirrors else [ (lib.last mirrors) ]);
    hash = "sha256-w+04GBFDk/P/XvW7T9PotGD0nQslMkV9codca2urNK4=";
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
    inherit lib fetchurl runCommand writeShellScript bash jdk perl python3 ruby snobol4 tk;
    texliveBinaries = bin;
  };

  tl = lib.mapAttrs (pname: { revision, extraRevision ? "", ... }@args:
    buildTeXLivePackage (args
      # NOTE: the fixed naming scheme must match generate-fixed-hashes.nix
      // { inherit mirrors pname; fixedHashes = fixedHashes."${pname}-${toString revision}${extraRevision}" or { }; }
      // lib.optionalAttrs (args ? deps) { deps = map (n: tl.${n}) (args.deps or [ ]); })
  ) overriddenTlpdb;

  # function for creating a working environment
  buildTeXEnv = import ./build-tex-env.nix {
    inherit bin tl;
    ghostscript = ghostscript_headless;
    inherit lib buildEnv libfaketime makeFontsConf makeWrapper runCommand
      writeShellScript writeText toTLPkgSets bash perl coreutils gawk gnugrep gnused;
  };

  ### texlive.combine compatibility layer:
  # convert TeX packages to { pkgs = [ ... ]; } lists
  # respecting specified outputs
  toTLPkgList = drv: if drv.outputSpecified or false
    then let tlType = drv.tlType or tlOutToType.${drv.tlOutputName or drv.outputName} or null; in
      lib.optional (tlType != null) (drv // { inherit tlType; })
    else [ (drv.tex // { tlType = "run"; }) ] ++
      lib.optional (drv ? texdoc) (drv.texdoc // { tlType = "doc"; } // lib.optionalAttrs (drv ? man) { hasManpages = true; }) ++
      lib.optional (drv ? texsource) (drv.texsource // { tlType = "source"; }) ++
      lib.optional (drv ? tlpkg) (drv.tlpkg // { tlType = "tlpkg"; }) ++
      lib.optional (drv ? out) (drv.out // { tlType = "bin"; });
  tlOutToType = { out = "bin"; tex = "run"; texsource = "source"; texdoc = "doc"; tlpkg = "tlpkg"; };

  # convert { pkgs = [ ... ]; } lists to TeX packages
  # possibly more than one, if pkgs is also used to specify dependencies
  tlTypeToOut = { run = "tex"; doc = "texdoc"; source = "texsource"; bin = "out"; tlpkg = "tlpkg"; };
  toSpecifiedNV = p: rec {
    name = value.tlOutputName;
    value = builtins.removeAttrs p [ "pkgs" ]
      // { outputSpecified = true; tlOutputName = tlTypeToOut.${p.tlType}; };
  };
  toTLPkgSet = pname: drvs:
    let set = lib.listToAttrs (builtins.map toSpecifiedNV drvs);
        mainDrv = set.out or set.tex or set.tlpkg or set.texdoc or set.texsource; in
    builtins.removeAttrs mainDrv [ "outputSpecified" ];
  toTLPkgSets = { pkgs, ... }: lib.mapAttrsToList toTLPkgSet
    (builtins.groupBy (p: p.pname) pkgs);

  # export TeX packages as { pkgs = [ ... ]; } in the top attribute set
  allPkgLists = lib.mapAttrs (n: drv: { pkgs = toTLPkgList drv; }) tl;

  # function for creating a working environment from a set of TL packages
  # now a legacy wrapper around buildTeXEnv
  combine = import ./combine-wrapper.nix { inherit buildTeXEnv lib toTLPkgList toTLPkgSets; };

  assertions = with lib;
    assertMsg (tlpdbVersion.year == version.texliveYear) "TeX Live year in texlive does not match tlpdb.nix, refusing to evaluate" &&
    assertMsg (tlpdbVersion.frozen == version.final) "TeX Live final status in texlive does not match tlpdb.nix, refusing to evaluate";

  # Pre-defined evironment packages for TeX Live schemes,
  # to make nix-env usage more comfortable and build selected on Hydra.

  # these license lists should be the sorted union of the licenses of the packages the schemes contain.
  # The correctness of this collation is tested by tests.texlive.licenses
  licenses = with lib.licenses; {
    scheme-basic = [ free gfl gpl1Only gpl2Only gpl2Plus knuth lgpl21 lppl1 lppl13c mit ofl publicDomain ];
    scheme-bookpub = [ artistic2 asl20 bsd3 fdl13Only free gfl gpl1Only gpl2Only gpl2Plus knuth lgpl21 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain ];
    scheme-context = [ bsd2 bsd3 cc-by-sa-40 free gfl gfsl gpl1Only gpl2Only gpl2Plus gpl3Only gpl3Plus knuth lgpl2 lgpl21
      lppl1 lppl13c mit ofl publicDomain x11 ];
    scheme-full = [ artistic1-cl8 artistic2 asl20 bsd2 bsd3 bsdOriginal cc-by-10 cc-by-20 cc-by-30 cc-by-40 cc-by-sa-10 cc-by-sa-20 cc-by-sa-30
      cc-by-sa-40 cc0 fdl13Only free gfl gfsl gpl1Only gpl2Only gpl2Plus gpl3Only gpl3Plus isc knuth lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a lppl13c mit
      ofl publicDomain x11 ];
    scheme-gust = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-40 cc-by-sa-40 cc0 fdl13Only free gfl gfsl gpl1Only gpl2Only
      gpl2Plus gpl3Only gpl3Plus knuth lgpl2 lgpl21 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
    scheme-infraonly = [ gpl2Plus lgpl21 ];
    scheme-medium = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-40 cc-by-sa-20 cc-by-sa-30 cc-by-sa-40 cc0 fdl13Only
      free gfl gpl1Only gpl2Only gpl2Plus gpl3Only gpl3Plus isc knuth lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a lppl13c mit ofl
      publicDomain x11 ];
    scheme-minimal = [ free gpl1Only gpl2Plus knuth lgpl21 lppl1 lppl13c mit ofl publicDomain ];
    scheme-small = [ asl20 cc-by-40 cc-by-sa-40 cc0 fdl13Only free gfl gpl1Only gpl2Only gpl2Plus gpl3Only gpl3Plus knuth
      lgpl2 lgpl21 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
    scheme-tetex = [ artistic1-cl8 asl20 bsd2 bsd3 cc-by-30 cc-by-40 cc-by-sa-10 cc-by-sa-20 cc-by-sa-30 cc-by-sa-40 cc0 fdl13Only free gfl gpl1Only
      gpl2Only gpl2Plus gpl3Only gpl3Plus isc knuth lgpl2 lgpl21 lgpl3 lppl1 lppl12 lppl13a lppl13c mit ofl publicDomain x11 ];
  };

  meta = {
    description = "TeX Live environment";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers;  [ veprbl ];
    license = licenses.scheme-infraonly;
  };

  combined = recurseIntoAttrs (
    lib.genAttrs [ "scheme-basic" "scheme-bookpub" "scheme-context" "scheme-full" "scheme-gust" "scheme-infraonly"
      "scheme-medium" "scheme-minimal" "scheme-small" "scheme-tetex" ]
      (pname:
        (buildTeXEnv {
          __extraName = "combined" + lib.removePrefix "scheme" pname;
          __extraVersion = with version; if final then "-final" else ".${year}${month}${day}";
          requiredTeXPackages = ps: [ ps.${pname} ];
          # to maintain full backward compatibility, enable texlive.combine behavior
          __combine = true;
        }).overrideAttrs {
          meta = meta // {
            description = "TeX Live environment for ${pname}";
            license = licenses.${pname};
          };
        }
      )
  );

  schemes = lib.listToAttrs (map (s: {
    name = "texlive" + s;
    value = lib.addMetaAttrs { license = licenses.${"scheme-" + (lib.toLower s)}; } (buildTeXEnv { requiredTeXPackages = ps: [ ps.${"scheme-" + (lib.toLower s)} ]; });
  }) [ "Basic" "BookPub" "ConTeXt" "Full" "GUST" "InfraOnly" "Medium" "Minimal" "Small" "TeTeX" ]);

in
  allPkgLists // {
    pkgs = tl;

    tlpdb = {
      # nested in an attribute set to prevent them from appearing in search
      nix = tlpdbNix;
      xz = tlpdbxz;
    };

    bin = assert assertions; bin // {
      # for backward compatibility
      latexindent = tl.latexindent;
    };

    combine = assert assertions; combine;

    combined = assert assertions; combined;

    inherit schemes;

    # convenience alias
    withPackages = (buildTeXEnv { }).withPackages;
  }
