/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ lib
, makeScopeWithSplicing', generateSplicesForMkScope
, recurseIntoAttrs
, fetchurl, runCommand
, ghostscript_headless, harfbuzz, biber, asymptote
, useFixedHashes ? true
}:
let
  tlpdb = import ./tlpdb.nix;

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

  tlpdbVersion = tlpdb."00texlive.config";

  assertions = with lib;
    assertMsg (tlpdbVersion.year == version.texliveYear) "TeX Live year in texlive does not match tlpdb.nix, refusing to evaluate" &&
    assertMsg (tlpdbVersion.frozen == version.final) "TeX Live final status in texlive does not match tlpdb.nix, refusing to evaluate";

  # the function defining the recursive attribute set that eventually makes up the texlive scope
  addPackages = self:
    let
      callPackage = self.newScope {
        biber = biber.override { texlive = self; };
        asymptote = asymptote.override { texLive = self.combine { inherit (self.pkgs) scheme-small epsf cm-super texinfo media9 ocgx2 collection-latexextra; }; };
        ghostscript = ghostscript_headless;
        harfbuzz = harfbuzz.override { withIcu = true; withGraphite2 = true; };
        inherit useFixedHashes;
        # make the tlpdb used by callPackage the "source" tlpdb above, not the one in the scope
        # TODO: rename one of them to make things less confusing
        inherit tlpdb;
      };
    in  {
      inherit callPackage;

      tlpdb = {
        # nested in an attribute set to prevent them from appearing in search
        nix = tlpdbNix;
        xz = tlpdbxz;
      };

      bin = assert assertions; callPackage ./bin.nix { };

      combine = assert assertions; callPackage ./combine.nix { };

      pkgs = let
        buildTeXLivePackage = callPackage ./build-texlive-package.nix { texliveBinaries = self.bin; };

        overrides = callPackage ./tlpdb-overrides.nix { tlpdbxz = self.tlpdb.xz; };

        overriddenTlpdb = overrides tlpdb;

        makePackageSet = tlpdb:
          lib.mapAttrs (pname: { revision, extraRevision ? "", ... }@args:
            buildTeXLivePackage (args
              # NOTE: the fixed naming scheme must match generate-fixed-hashes.nix
              // { inherit mirrors pname; fixedHashes = fixedHashes."${pname}-${toString revision}${extraRevision}" or { }; }
              // lib.optionalAttrs (args ? deps) { deps = map (n: self.pkgs.${n}) (args.deps or [ ]); })
          ) tlpdb;

      in lib.makeOverridable makePackageSet overriddenTlpdb;


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
            (self.combine {
              ${pname} = attrs;
              extraName = "combined" + lib.removePrefix "scheme" pname;
              extraVersion = with version; if final then "-final" else ".${year}${month}${day}";
            })
          )
          { inherit (self.pkgs)
              scheme-basic scheme-context scheme-full scheme-gust scheme-infraonly
              scheme-medium scheme-minimal scheme-small scheme-tetex;
          }
      );
  };

  texlive = makeScopeWithSplicing' {
    otherSplices = generateSplicesForMkScope "texlive";
    f = addPackages;
  };

  applyOverScope = f: scope: f (scope // {
      overrideScope = g: applyOverScope f (scope.overrideScope g);
  });

  # for backward compability
  compatFixups = scope:
    # TODO
    scope.pkgs // # remove this line to fix cross
    scope // {
      bin = scope.bin // {
        latexindent = lib.findFirst (p: p.tlType == "bin") scope.pkgs.latexindent.pkgs;
      };
    };

in applyOverScope compatFixups texlive
