/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: http://nixos.org/nixpkgs/manual/#sec-language-texlive

  Note on upgrading: The texlive package contains a few binaries, defined in
  bin.nix and released once a year, and several thousand packages from CTAN,
  defined in pkgs.nix.

  The CTAN mirrors are continuously moving, with more than 100 updates per
  month. Due to the size of the distribution, we snapshot it and generate nix
  expressions for all packages in texlive at that point.

  To upgrade this snapshot, run the following:
  $ curl http://mirror.ctan.org/tex-archive/systems/texlive/tlnet/tlpkg/texlive.tlpdb.xz \
             | xzcat | uniq -u | sed -rn -f ./tl2nix.sed > ./pkgs.nix

  This will regenerate all of the sha512 hashes for the current upstream
  distribution. You may want to find a more stable mirror, put the distribution
  on IPFS, or contact a maintainer to get the tarballs from that point in time
  into a more stable location, so that nix users who are building from source
  can reproduce your work.

  Upgrading the bin: texlive itself is a large collection of binaries. In order
  to reduce closure size for users who just need a few of them, we split it into
  packages such as core, core-big, xvdi, etc. This requires making assumptions
  about dependencies between the projects that may change between releases; if
  you upgrade you may have to do some work here.
*/
{ stdenv, lib, fetchurl, runCommand, writeText, buildEnv
, callPackage, ghostscriptX, harfbuzz, poppler_min
, makeWrapper, python, ruby, perl
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

  # function for creating a working environment from a set of TL packages
  combine = import ./combine.nix {
    inherit bin combinePkgs buildEnv fastUnique lib makeWrapper writeText
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

      urls = args.urls or (if args ? url then [ args.url ] else
              map (up: "${up}/${urlName}.tar.xz") urlPrefixes
            );

      # Upstream refuses to distribute stable tarballs, so we host snapshots on IPFS.
      # Common packages should get served from the binary cache anyway.
      # See discussions, e.g. https://github.com/NixOS/nixpkgs/issues/24683
      urlPrefixes = args.urlPrefixes or [
        # Should be stable for historic, archived releases
        http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2017/tlnet-final/archive

        # TODO: Add IPFS and see if @veprbl is willing to add a texlive-2017-final mirror,
        # or if we should just dump it and go to 2018.

        # The canonical source moves quickly and will be broken almost immediately
        # http://mirror.ctan.org/tex-archive/systems/texlive/tlnet/archive
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

    in runCommand "texlive-${tlName}" {
        # lots of derivations, not meant to be cached
        preferLocalBuild = true; allowSubstitutes = false;
        inherit passthru;
      }
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
        { inherit (tl)
            scheme-basic scheme-context scheme-full scheme-gust
            scheme-medium scheme-minimal scheme-small scheme-tetex;
        }
    );
  }
