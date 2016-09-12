/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: http://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscriptX, harfbuzz, poppler_min
, makeWrapper, perl, python, ruby
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
  # warning: the following generator command takes lots of resources
  # nix-build ../../../../.. -Q -A texlive.scheme-full.pkgs | ./fixHashes.sh > ./fixedHashes-new.nix
  # mv ./fixedHashes{-new,}.nix
  fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixedHashes.nix);

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin combinePkgs buildEnv fastUnique lib makeWrapper writeText
      perl stdenv python ruby;
  };

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  tl = let
    /* # beware: the URL below changes contents continuously
      curl http://mirror.ctan.org/tex-archive/systems/texlive/tlnet/tlpkg/texlive.tlpdb.xz \
        | xzcat | uniq -u | sed -rn -f ./tl2nix.sed > ./pkgs.nix */
    orig = import ./pkgs.nix tl; # XXX XXX XXX FIXME: the file is probably too big now XXX XXX XXX XXX XXX XXX
    clean = orig // {
      # overrides of texlive.tlpdb

      dvidvi = orig.dvidvi // {
        hasRunfiles = false; # only contains docs that's in bin.core.doc already
      };
      texlive-msg-translations = orig.texlive-msg-translations // {
        hasRunfiles = false; # only *.po for tlmgr
      };

      xdvi = orig.xdvi // { # it seems to need it to transform fonts
        deps = (orig.xdvi.deps or {}) // { inherit (tl) metafont; };
      };

      # remove dependency-heavy packages from the basic collections
      collection-basic = orig.collection-basic // {
        deps = removeAttrs orig.collection-basic.deps [ "luatex" "metafont" "xdvi" ];
      };
      latex = orig.latex // {
        deps = removeAttrs orig.latex.deps [ "luatex" ];
      };
      # add them elsewhere so that collections cover all packages
      collection-luatex = orig.collection-luatex // {
        deps = orig.collection-luatex.deps // { inherit (tl) luatex; };
      };
      collection-metapost = orig.collection-metapost // {
        deps = orig.collection-metapost.deps // { inherit (tl) metafont; };
      };
      collection-genericextra = orig.collection-genericextra // {
        deps = orig.collection-genericextra.deps // { inherit (tl) xdvi; };
      };
    }; # overrides

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
        ++ lib.optional (attrs.sha512 ? "doc") (mkPkgV "doc")
        ++ lib.optional (attrs.sha512 ? "source") (mkPkgV "source")
        ++ lib.optional (bin ? ${pname})
            ( bin.${pname} // { inherit pname; tlType = "bin"; } )
        ++ combinePkgs (attrs.deps or {});
    };

  # create a derivation that contains an unpacked upstream TL package
  mkPkg = { pname, tlType, version, sha512, postUnpack ? "", stripPrefix ? 1, ... }@args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + lib.optionalString (tlType != "run") ".${tlType}";
      tlName = urlName + "-${version}";
      fixedHash = fixedHashes.${tlName} or null; # be graceful about missing hashes

      url = args.url or "${urlPrefix}/${urlName}.tar.xz";
      urlPrefix = args.urlPrefix or
        http://lipa.ms.mff.cuni.cz/~cunav5am/nix/texlive-2016;
      # XXX XXX XXX FIXME: mirror the snapshot XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX
      #  ("${mirror}/pub/tex/historic/systems/texlive/${bin.texliveYear}/tlnet-final/archive");
      #mirror = "http://ftp.math.utah.edu";
      src = fetchurl { inherit url sha512; };

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
        inherit url;
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

  # TODO: replace by buitin once it exists
  fastUnique = comparator: list: with lib;
    let un_adj = l: if length l < 2 then l
      else optional (head l != elemAt l 1) (head l) ++ un_adj (tail l);
    in un_adj (lib.sort comparator list);

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
            maintainers = [ lib.maintainers.vcunat ];
          }
          (combine {
            ${pname} = attrs;
            extraName = "combined" + lib.removePrefix "scheme" pname;
          })
        )
        { inherit (tl) scheme-full
            scheme-tetex scheme-medium scheme-small scheme-basic scheme-minimal
            scheme-context scheme-gust scheme-xml;
        }
    );
  }

