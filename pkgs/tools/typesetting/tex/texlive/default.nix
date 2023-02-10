/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscript_headless, harfbuzz
, makeWrapper, python3, ruby, perl, gnused, gnugrep, coreutils
, libfaketime
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
  };

  # map: name -> fixed-output hash
  fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixedHashes.nix);

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin combinePkgs buildEnv lib makeWrapper writeText
      stdenv python3 ruby perl gnused gnugrep coreutils libfaketime;
    ghostscript = ghostscript_headless;
  };

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  tl = let
    orig = import ./pkgs.nix tl;
    removeSelfDep = lib.mapAttrs
      (n: p: if p ? deps then p // { deps = lib.filterAttrs (dn: _: n != dn) p.deps; }
                         else p);
    clean = removeSelfDep (orig // {
      # overrides of texlive.tlpdb

      texlive-msg-translations = orig.texlive-msg-translations // {
        hasRunfiles = false; # only *.po for tlmgr
      };

      xdvi = orig.xdvi // { # it seems to need it to transform fonts
        deps = (orig.xdvi.deps or {}) // { inherit (tl) metafont; };
      };

      # remove dependency-heavy packages from the basic collections
      collection-basic = orig.collection-basic // {
        deps = removeAttrs orig.collection-basic.deps [ "metafont" "xdvi" ];
      };
      # add them elsewhere so that collections cover all packages
      collection-metapost = orig.collection-metapost // {
        deps = orig.collection-metapost.deps // { inherit (tl) metafont; };
      };
      collection-plaingeneric = orig.collection-plaingeneric // {
        deps = orig.collection-plaingeneric.deps // { inherit (tl) xdvi; };
      };

      # override cyclic dependency until #167226 is fixed
      xecjk = orig.xecjk // {
        deps = removeAttrs orig.xecjk.deps [ "ctex" ];
      };

      texdoc = orig.texdoc // {
        # build Data.tlpdb.lua (part of the 'tlType == "run"' package)
        postUnpack = ''
          if [[ -f "$out"/scripts/texdoc/texdoc.tlu ]]; then
            unxz --stdout "${tlpdb}" > texlive.tlpdb

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
    }); # overrides

    # tl =
    in lib.mapAttrs flatDeps clean;
    # TODO: texlive.infra for web2c config?


  flatDeps = pname: attrs:
    let
      version = attrs.version or (builtins.toString attrs.revision);
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
          }
        )]
        ++ lib.optional (attrs.sha512 ? doc) (mkPkgV "doc")
        ++ lib.optional (attrs.sha512 ? source) (mkPkgV "source")
        ++ lib.optional (bin ? ${pname})
            ( bin.${pname} // { inherit pname; tlType = "bin"; } )
        ++ combinePkgs (attrs.deps or {});
    };

  # for daily snapshots
  snapshot = {
    year = "2022";
    month = "12";
    day = "27";
  };

  tlpdb = fetchurl {
    # use the same mirror(s) as urlPrefixes below
    urls = [
      #"http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${bin.texliveYear}/tlnet-final/tlpkg/texlive.tlpdb.xz"
      #"ftp://tug.org/texlive/historic/${bin.texliveYear}/tlnet-final/tlpkg/texlive.tlpdb.xz"
      "https://texlive.info/tlnet-archive/${snapshot.year}/${snapshot.month}/${snapshot.day}/tlnet/tlpkg/texlive.tlpdb.xz"
    ];
    hash = "sha256-i8DE3/rZmtp+gODJWeHV1VcCK5cgHUgmywf3Q/agTOA=";
  };

  # create a derivation that contains an unpacked upstream TL package
  mkPkg = { pname, tlType, revision, version, sha512, postUnpack ? "", stripPrefix ? 1, ... }@args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + lib.optionalString (tlType != "run") ".${tlType}";
      tlName = urlName + "-${version}";
      fixedHash = fixedHashes.${tlName} or null; # be graceful about missing hashes

      urls = args.urls or (if args ? url then [ args.url ] else
        map (up: "${up}/${urlName}.r${toString revision}.tar.xz") urlPrefixes);

      # The tarballs on CTAN mirrors for the current release are constantly
      # receiving updates, so we can't use those directly. Stable snapshots
      # need to be used instead. Ideally, for the release branches of NixOS we
      # should be switching to the tlnet-final versions
      # (https://tug.org/historic/).
      urlPrefixes = args.urlPrefixes or [
        # tlnet-final snapshot
        #"http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${bin.texliveYear}/tlnet-final/archive"
        #"ftp://tug.org/texlive/historic/${bin.texliveYear}/tlnet-final/archive"

        # Daily snapshots hosted by one of the texlive release managers
        "https://texlive.info/tlnet-archive/${snapshot.year}/${snapshot.month}/${snapshot.day}/tlnet/archive"
      ];

    in runCommand "texlive-${tlName}"
      ( {
          src = fetchurl { inherit urls sha512; };
          inherit stripPrefix;
          # metadata for texlive.combine
          passthru = {
            inherit pname tlType version;
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
  combinePkgs = pkgSet: lib.concatLists # uniqueness is handled in `combine`
    (lib.mapAttrsToList (_n: a: a.pkgs) pkgSet);

in
  tl // {
    inherit bin combine;

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
            #extraVersion = "-final";
            extraVersion = ".${snapshot.year}${snapshot.month}${snapshot.day}";
          })
        )
        { inherit (tl)
            scheme-basic scheme-context scheme-full scheme-gust scheme-infraonly
            scheme-medium scheme-minimal scheme-small scheme-tetex;
        }
    );
  }
