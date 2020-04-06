/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: http://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscriptX, harfbuzz, poppler_min
, makeWrapper, python, ruby, perl
, useFixedHashes ? true
, recurseIntoAttrs
}:
let
  # various binaries (compiled)
  bin = callPackage ./bin.nix {
    poppler = poppler_min; # otherwise depend on various X stuff
    ghostscript = ghostscriptX;
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  };

  # map: name -> fixed-output hash
  # sha1 in base32 was chosen as a compromise between security and length
  fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixedHashes.nix);

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin combinePkgs buildEnv lib makeWrapper writeText
      stdenv python ruby perl;
    ghostscript = ghostscriptX; # could be without X, probably, but we use X above
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
    }); # overrides

    # tl =
    in lib.mapAttrs flatDeps clean;
    # TODO: texlive.infra for web2c config?


  flatDeps = pname: attrs:
    let
      version = attrs.version or bin.texliveYear;
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
            # the fake derivations are used for filtering of hyphenation patterns
          else { inherit pname version; tlType = "run"; }
        )]
        ++ lib.optional (attrs.sha512 ? doc) (mkPkgV "doc")
        ++ lib.optional (attrs.sha512 ? source) (mkPkgV "source")
        ++ lib.optional (bin ? ${pname})
            ( bin.${pname} // { inherit pname; tlType = "bin"; } )
        ++ combinePkgs (attrs.deps or {});
    };

  # create a derivation that contains an unpacked upstream TL package
  mkPkg = { pname, tlType, revision, version, sha512, postUnpack ? "", stripPrefix ? 1, ... }@args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + lib.optionalString (tlType != "run") ".${tlType}";
      tlName = urlName + "-${version}";
      fixedHash = fixedHashes.${tlName} or null; # be graceful about missing hashes

      urls = args.urls or (if args ? url then [ args.url ] else
        lib.concatMap
          (up: [
            "${up}/${urlName}.r${toString revision}.tar.xz"
            "${up}/${urlName}.tar.xz" # TODO To be removed for telive 2020
          ])
          urlPrefixes);

      # The tarballs on CTAN mirrors for the current release are constantly
      # receiving updates, so we can't use those directly. Stable snapshots
      # need to be used instead. Ideally, for the release branches of NixOS we
      # should be switching to the tlnet-final versions
      # (https://tug.org/historic/).
      urlPrefixes = args.urlPrefixes or [
        # tlnet-final snapshot
        http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2019/tlnet-final/archive
        ftp://tug.org/texlive/historic/2019/tlnet-final/archive

        # Daily snapshots hosted by one of the texlive release managers
        #https://texlive.info/tlnet-archive/2019/10/19/tlnet/archive
      ];

      src = fetchurl { inherit urls sha512; };

      passthru = {
        inherit pname tlType version;
      } // lib.optionalAttrs (sha512 != "") { inherit src; };
      unpackCmd = file: ''
        tar -xf ${file} \
          '--strip-components=${toString stripPrefix}' \
          -C "$out" --anchored --exclude=tlpkg --keep-old-files
      '' + postUnpack;

    in if sha512 == "" then
      # hash stripped from pkgs.nix to save space -> fetch&unpack in a single step
      fetchurl {
        inherit urls;
        sha1 = if fixedHash == null then throw "TeX Live package ${tlName} is missing hash!"
          else fixedHash;
        name = tlName;
        recursiveHash = true;
        downloadToTemp = true;
        postFetch = ''mkdir "$out";'' + unpackCmd "$downloadedFile";
        # TODO: perhaps override preferHashedMirrors and allowSubstitutes
     }
        // passthru

    else runCommand "texlive-${tlName}"
      ( { # lots of derivations, not meant to be cached
          preferLocalBuild = true; allowSubstitutes = false;
          inherit passthru;
        } // lib.optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha1";
          outputHashMode = "recursive";
        }
      )
      ( ''
          mkdir "$out"
        '' + unpackCmd "'${src}'"
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
            hydraPlatforms = lib.optionals
              (lib.elem pname ["scheme-small" "scheme-basic"]) platforms;
            maintainers = with lib.maintainers;  [ veprbl ];
          }
          (combine {
            ${pname} = attrs;
            extraName = "combined" + lib.removePrefix "scheme" pname;
          })
        )
        { inherit (tl)
            scheme-basic scheme-context scheme-full scheme-gust scheme-infraonly
            scheme-medium scheme-minimal scheme-small scheme-tetex;
        }
    );
  }
