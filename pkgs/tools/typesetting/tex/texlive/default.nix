/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscript_headless, harfbuzz
, makeWrapper, python3, ruby, perl, gnused, gnugrep, coreutils
, libfaketime, makeFontsConf
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
    inherit bin combinePkgs buildEnv lib makeWrapper writeText runCommand
      stdenv python3 ruby perl gnused gnugrep coreutils libfaketime makeFontsConf;
    ghostscript = ghostscript_headless;
  };

  tlpdb = import ./tlpdb.nix;

  tlpdbVersion = tlpdb."00texlive.config";

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  tl = let
    orig = removeAttrs tlpdb [ "00texlive.config" ];

    overridden = orig // {
      # overrides of texlive.tlpdb

      # only *.po for tlmgr
      texlive-msg-translations = builtins.removeAttrs orig.texlive-msg-translations [ "hasTlpkg" ];

      xdvi = orig.xdvi // { # it seems to need it to transform fonts
        deps = (orig.xdvi.deps or []) ++  [ "metafont" ];
      };

      arabi-add = orig.arabi-add // {
        # tlpdb lists license as "unknown", but the README says lppl13: http://mirrors.ctan.org/language/arabic/arabi-add/README
        license = [  "lppl13c" ];
      };

      # TODO: remove this when updating to texlive-2023, npp-for-context is no longer in texlive
      npp-for-context = orig.npp-for-context // {
        # tlpdb lists license as "noinfo", but it's gpl3: https://github.com/luigiScarso/context-npp
        license = [  "gpl3Only" ];
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
        extraRevision = ".tlpdb${toString tlpdbVersion.revision}";
        extraVersion = "-tlpdb-${toString tlpdbVersion.revision}";

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

  # create a TeX package: an attribute set { pkgs = [ ... ]; ... } where pkgs is a list of derivations
  mkTLPkg = pname: attrs:
    let
      version = attrs.version or (toString attrs.revision);
      mkPkgV = tlType: let
        pkg = attrs // {
          sha512 = attrs.sha512.${if tlType == "tlpkg" then "run" else tlType};
          inherit pname tlType version;
        };
        in mkPkg pkg;
    in {
      # TL pkg contains lists of packages: runtime files, docs, sources, tlpkg, binaries
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
        ++ lib.optional (attrs.hasTlpkg or false) (mkPkgV "tlpkg")
        ++ lib.optional (bin ? ${pname})
            ( bin.${pname} // { tlType = "bin"; } );
    };

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
  urlPrefixes = with version; lib.optionals final  [
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
    urls = map (up: "${up}/tlpkg/texlive.tlpdb.xz") urlPrefixes;
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

  # NOTE: the fixed naming scheme must match generated-fixed-hashes.nix
  # name for the URL
  mkURLName = { pname, tlType, ... }: pname + lib.optionalString (tlType != "run" && tlType != "tlpkg") ".${tlType}";
  # name + revision for the fixed output hashes
  mkFixedName = { tlType, revision, extraRevision ? "", ... }@attrs: mkURLName attrs + (lib.optionalString (tlType == "tlpkg") ".tlpkg") + ".r${toString revision}${extraRevision}";
  # name + version for the derivation
  mkTLName = { tlType, version, extraVersion ? "", ... }@attrs: mkURLName attrs + (lib.optionalString (tlType == "tlpkg") ".tlpkg") + "-${version}${extraVersion}";

  # create a derivation that contains an unpacked upstream TL package
  mkPkg = { pname, tlType, revision, version, sha512, extraRevision ? "", postUnpack ? "", stripPrefix ? 1, ... }@args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = mkURLName args;
      tlName = mkTLName args;
      fixedHash = fixedHashes.${mkFixedName args} or null; # be graceful about missing hashes

      urls = args.urls or (if args ? url then [ args.url ] else
        map (up: "${up}/archive/${urlName}.r${toString revision}.tar.xz") (args.urlPrefixes or urlPrefixes));

    in runCommand "texlive-${tlName}"
      ( {
          src = fetchurl { inherit urls sha512; };
          meta = {
            license = map (x: lib.licenses.${x}) (args.license or []);
          };
          inherit stripPrefix tlType;
          # metadata for texlive.combine
          passthru = {
            inherit pname tlType revision version extraRevision;
          } // lib.optionalAttrs (tlType == "run" && args ? deps) {
            tlDeps = map (n: tl.${n}) args.deps;
          } // lib.optionalAttrs (tlType == "run") {
            hasFormats = args.hasFormats or false;
            hasHyphens = args.hasHyphens or false;
          } // lib.optionalAttrs (tlType == "tlpkg" && args ? postactionScript) {
            postactionScript = args.postactionScript;
          };
        } // lib.optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        }
      )
      ( ''
          mkdir "$out"
          if [[ "$tlType"  == "tlpkg" ]]; then
            tar -xf "$src" \
              --strip-components=1 \
              -C "$out" --anchored --exclude=tlpkg/tlpobj --exclude=tlpkg/installer --exclude=tlpkg/gpg --keep-old-files \
              tlpkg
          else
            tar -xf "$src" \
              --strip-components="$stripPrefix" \
              -C "$out" --anchored --exclude=tlpkg --keep-old-files
          fi
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

  assertions = with lib;
    assertMsg (tlpdbVersion.year == version.texliveYear) "TeX Live year in texlive does not match tlpdb.nix, refusing to evaluate" &&
    assertMsg (tlpdbVersion.frozen == version.final) "TeX Live final status in texlive does not match tlpdb.nix, refusing to evaluate" &&
    (!useFixedHashes ||
      (let all = concatLists (catAttrs "pkgs" (attrValues tl));
         fods = filter (p: isDerivation p && p.tlType != "bin") all;
      in builtins.all (p: assertMsg (p ? outputHash) "The TeX Live package '${p.pname + lib.optionalString (p.tlType != "run") ("." + p.tlType)}' does not have a fixed output hash. Please read UPGRADING.md on how to build a new 'fixed-hashes.nix'.") fods));

in
  tl // {

    tlpdb = {
      # nested in an attribute set to prevent them from appearing in search
      nix = tlpdbNix;
      xz = tlpdbxz;
    };

    bin = assert assertions; bin;
    combine = assert assertions; combine;

    # Pre-defined combined packages for TeX Live schemes,
    # to make nix-env usage more comfortable and build selected on Hydra.
    combined = with lib; recurseIntoAttrs (
      mapAttrs
        (pname: attrs:
          addMetaAttrs rec {
            description = "TeX Live environment for ${pname}";
            platforms = lib.platforms.all;
            maintainers = with lib.maintainers;  [ veprbl ];
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
