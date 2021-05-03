/* TeX Live user docs
  - source: ../../../../../doc/languages-frameworks/texlive.xml
  - current html: https://nixos.org/nixpkgs/manual/#sec-language-texlive
*/
let
  fixedHashes' = import ./fixedHashes.nix;
  tlPkgs = import ./pkgs.nix;
in
{ lib, newScope
, ghostscriptX, harfbuzz, poppler_min
, useFixedHashes ? true
, recurseIntoAttrs
}:
let
  # For use with `lib.makeScope`.
  applyOverScope = f: scope: f (scope // {
    overrideScope = g: applyOverScope f (scope.overrideScope g);
    overrideScope' = g: applyOverScope f (scope.overrideScope' g);
  });
  # For use with `lib.makeScope'` or `lib.makeScopeWithSplicing`.
  applyOverScope' = f: scope: f (scope // {
    overrideScope = g: applyOverScope' f (scope.overrideScope g);
  });

  # map: name -> fixed-output hash
  # sha1 in base32 was chosen as a compromise between security and length
  fixedHashes = lib.optionalAttrs useFixedHashes fixedHashes';

  # From pkgs/top-level/aliases.nix
  removeRecurseForDerivations = alias:
    if alias.recurseForDerivations or false then
      removeAttrs alias ["recurseForDerivations"]
    else alias;
  removeDistribute = alias:
    if lib.isDerivation alias then
      lib.dontDistribute alias
    else alias;
  checkInPkgs = super: n: alias: if builtins.hasAttr n super
    then throw "Alias ${n} is still in texlive"
    else alias;
  mapAliases = super:
    let checkInPkgs' = checkInPkgs super; in
    lib.mapAttrs (n: alias:
      removeDistribute (removeRecurseForDerivations (checkInPkgs' n alias))
    );

  warnRenamed = from: to: lib.warn
    "Obsolete attribute `${from}' is used. It was renamed to `${to}'.";

  # overrides of higher-scoped packages within texlive
  newScope' = scope: newScope ({
    ghostscript = ghostscriptX;
    poppler = poppler_min; # otherwise depend on various X stuff
    harfbuzz = harfbuzz.override {
      withIcu = true; withGraphite2 = true;
    };
  } // scope);

  texliveFinalizer = super:
    super.texlivePackages //
    mapAliases super {
      bin = warnRenamed "bin" "texliveBin" super.texliveBin; # added 2020-04-24
      combine = super.buildTexliveCombinedEnv; # added 2020-04-24
    } //
    super;
in
applyOverScope texliveFinalizer (lib.makeScope newScope' (self: let
  inherit (self) callPackage;
in {
  # various binaries (compiled)
  texliveBin = callPackage ./bin.nix { };

  texliveSnapshot = {
    year = "2021";
    month = "04";
    day = "08";
  };

  # create a derivation that contains an unpacked upstream TL package
  buildTexlivePackage = callPackage (
    { lib, fetchurl, runCommand
    , texliveSnapshot
    }:
    let
      inherit (lib) optionalAttrs optionalString;
      snapshot = texliveSnapshot;
    in

    { pname, tlType
    , revision, version, sha512
    , postUnpack ? ""
    , stripPrefix ? 1
    , ... } @ args:
    let
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + optionalString (tlType != "run") ".${tlType}";
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
        #"http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2019/tlnet-final/archive"
        #"ftp://tug.org/texlive/historic/2019/tlnet-final/archive"

        # Daily snapshots hosted by one of the texlive release managers
        "https://texlive.info/tlnet-archive/${snapshot.year}/${snapshot.month}/${snapshot.day}/tlnet/archive"
      ];

      src = fetchurl { inherit urls sha512; };

      passthru = {
        inherit pname tlType version;
      } // optionalAttrs (sha512 != "") { inherit src; };
      unpackCmd = file: ''
        tar -xf ${file} \
          '--strip-components=${toString stripPrefix}' \
          -C "$out" --anchored --exclude=tlpkg --keep-old-files
      '' + postUnpack;

    in if sha512 == ""
      # hash stripped from pkgs.nix to save space -> fetch&unpack in a single step
      then fetchurl {
        inherit urls;
        sha1 = if fixedHash == null then throw "TeX Live package ${tlName} is missing hash!"
          else fixedHash;
        name = tlName;
        recursiveHash = true;
        downloadToTemp = true;
        postFetch = ''mkdir "$out";'' + unpackCmd "$downloadedFile";
        # TODO: perhaps override preferHashedMirrors and allowSubstitutes
      } // passthru

      else runCommand "texlive-${tlName}"
        ({ # lots of derivations, not meant to be cached
          preferLocalBuild = true; allowSubstitutes = false;
          inherit passthru;
        } // optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha1";
          outputHashMode = "recursive";
        })
        (''
          mkdir "$out"
        '' + unpackCmd "'${src}'")
  ) { };

  # combine a set of TL packages into a single TL meta-package
  combineTexlivePackages = let
    inherit (lib) concatLists mapAttrsToList;
  in pkgSet: concatLists # uniqueness is handled in `buildTexliveCombinedEnv`
    (mapAttrsToList (_n: a: a.pkgs) pkgSet);

  flattenTexlivePackage = let
    inherit (lib) optional;
    inherit (self) texliveBin buildTexlivePackage combineTexlivePackages;
  in pname: args:
    let
      version = args.version or (builtins.toString args.revision);
      buildTexlivePackageV = tlType: buildTexlivePackage (args // {
        sha512 = args.sha512.${tlType};
        inherit pname tlType version;
      });
    in {
      # TL pkg contains lists of packages: runtime files, docs, sources, binaries
      pkgs =
        # tarball of a collection/scheme itself only contains a tlobj file
        [(if (args.hasRunfiles or false) then buildTexlivePackageV "run"
          # the fake derivations are used for filtering of hyphenation patterns
          else { inherit pname version; tlType = "run"; })]
        ++ optional (args.sha512 ? doc) (buildTexlivePackageV "doc")
        ++ optional (args.sha512 ? source) (buildTexlivePackageV "source")
        ++ optional (texliveBin ? ${pname})
            (texliveBin.${pname} // { inherit pname; tlType = "bin"; })
        ++ combineTexlivePackages (args.deps or {});
    };

  # function for creating a working environment from a set of TL packages.
  # `ghostscript` could be without X, probably, but we use X for `texliveBin`.
  buildTexliveCombinedEnv = callPackage ./combine.nix { };

  # the set of TeX Live packages, collections, and schemes; using upstream naming
  originalTexlivePackages = tlPkgs self.texlivePackages;
  texlivePackages = let
    inherit (lib) filterAttrs mapAttrs;
    inherit (self) flattenTexlivePackage;
    tl = self.texlivePackages;
    origTl = self.originalTexlivePackages;
    removeSelfDep = mapAttrs
      (n: p: if p ? deps then p // { deps = filterAttrs (dn: _: n != dn) p.deps; }
                         else p);
    clean = removeSelfDep (origTl // {
      # overrides of texlive.tlpdb

      texlive-msg-translations = origTl.texlive-msg-translations // {
        hasRunfiles = false; # only *.po for tlmgr
      };

      xdvi = origTl.xdvi // { # it seems to need it to transform fonts
        deps = (origTl.xdvi.deps or {}) // { inherit (tl) metafont; };
      };

      # remove dependency-heavy packages from the basic collections
      collection-basic = origTl.collection-basic // {
        deps = removeAttrs origTl.collection-basic.deps [ "metafont" "xdvi" ];
      };
      # add them elsewhere so that collections cover all packages
      collection-metapost = origTl.collection-metapost // {
        deps = origTl.collection-metapost.deps // { inherit (tl) metafont; };
      };
      collection-plaingeneric = origTl.collection-plaingeneric // {
        deps = origTl.collection-plaingeneric.deps // { inherit (tl) xdvi; };
      };
    }); # overrides
  in mapAttrs flattenTexlivePackage clean;
  # TODO: texlive.infra for web2c config?

  buildTexliveSchemeEnv = let
    inherit (lib) addMetaAttrs removePrefix;
    inherit (self) buildTexliveCombinedEnv;
    snapshot = self.texliveSnapshot;
  in pname: pkg:
    addMetaAttrs {
      description = "TeX Live environment for ${pname}";
      platforms = lib.platforms.all;
      maintainers = [ lib.maintainers.veprbl ];
    } (buildTexliveCombinedEnv {
      ${pname} = pkg;
      extraName = "combined" + removePrefix "scheme" pname;
      extraVersion = ".${snapshot.year}${snapshot.month}${snapshot.day}";
    });

  # Pre-defined combined packages for TeX Live schemes,
  # to make nix-env usage more comfortable and build selected on Hydra.
  combined = recurseIntoAttrs (lib.mapAttrs self.buildTexliveSchemeEnv {
    inherit (self.texlivePackages)
      scheme-basic scheme-context scheme-full scheme-gust scheme-infraonly
      scheme-medium scheme-minimal scheme-small scheme-tetex;
  });
}))
