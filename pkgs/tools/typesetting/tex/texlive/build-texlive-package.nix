{ lib
, fetchurl
, runCommand

  # script interpreters
, bash
, jdk
, perl
, python3
, ruby
, snobol4
, tk

  # TeX Live prerequisites
, texliveBinaries
}:

{ pname
, revision
, version ? toString revision
, sha512
, mirrors
, extraVersion ? ""
, fixedHashes ? { }
, postUnpack ? ""
, stripPrefix ? 1
, license ? [ ]
, hasHyphens ? false
, hasManpages ? false
, hasRunfiles ? false
, hasTlpkg ? false
, extraNativeBuildInputs ? [ ]
, ...
}@args:

let
  meta = { license = map (x: lib.licenses.${x}) license; };

  commonPassthru = {
    inherit pname revision version;
  } // lib.optionalAttrs (args ? extraRevision) {
    inherit (args) extraRevision;
  };

  # build run, doc, source, tlpkg containers
  mkContainer = tlType: passthru: sha512:
    let
      # NOTE: the fixed naming scheme must match generated-fixed-hashes.nix
      # the basename used by upstream (without ".tar.xz" suffix)
      urlName = pname + (lib.optionalString (tlType != "run" && tlType != "tlpkg") ".${tlType}");
      # name + version for the derivation
      tlName = urlName + (lib.optionalString (tlType == "tlpkg") ".tlpkg") + "-${version}${extraVersion}";
      fixedHash = fixedHashes.${tlType} or null; # be graceful about missing hashes

      urls = args.urls or (if args ? url then [ args.url ] else
      map (up: "${up}/archive/${urlName}.r${toString revision}.tar.xz") mirrors);
    in
    runCommand "texlive-${tlName}"
      ({
        src = fetchurl { inherit urls sha512; };
        inherit meta passthru stripPrefix tlType;
      } // lib.optionalAttrs (fixedHash != null) {
        outputHash = fixedHash;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
      })
      (''
        mkdir "$out"
        if [[ "$tlType"  == "tlpkg" ]]; then
          tar -xf "$src" \
            --strip-components=1 \
            -C "$out" --anchored --exclude=tlpkg/tlpobj --keep-old-files \
            tlpkg
        else
          tar -xf "$src" \
            --strip-components="$stripPrefix" \
            -C "$out" --anchored --exclude=tlpkg --keep-old-files
        fi
      '' + postUnpack);

  tex = [
    (
      let passthru = commonPassthru
        // lib.optionalAttrs (args ? deps) { tlDeps = args.deps; }
        // lib.optionalAttrs (args ? formats) { inherit (args) formats; }
        // lib.optionalAttrs hasHyphens { inherit hasHyphens; }; in
      if hasRunfiles then mkContainer "run" passthru sha512.run
      else (passthru // { tlType = "run"; })
    )
  ];

  doc = let passthru = commonPassthru
    // lib.optionalAttrs hasManpages { inherit hasManpages; }; in
    lib.optional (sha512 ? doc) (mkContainer "doc" passthru sha512.doc);

  source = lib.optional (sha512 ? source) (mkContainer "source" commonPassthru sha512.source);

  tlpkg = let passthru = commonPassthru
    // lib.optionalAttrs (args ? postactionScript) { postactionScript = args.postactionScript; }; in
    lib.optional hasTlpkg (mkContainer "tlpkg" passthru sha512.run);

  bin = lib.optional (args ? binfiles && args.binfiles != [ ]) (
    let
      # find interpreters for the script extensions found in tlpdb
      extToInput = {
        jar = jdk;
        lua = texliveBinaries.luatex;
        py = python3;
        rb = ruby;
        sno = snobol4;
        tcl = tk;
        texlua = texliveBinaries.luatex;
        tlu = texliveBinaries.luatex;
      };
      run = lib.head tex;
    in
    runCommand "texlive-${pname}.bin-${version}"
      {
        passthru = commonPassthru // { tlType = "bin"; };
        inherit meta;
        # shebang interpreters and compiled binaries
        buildInputs = let outName = builtins.replaceStrings [ "-" ] [ "_" ] pname; in
          [ texliveBinaries.core.${outName} or null
            texliveBinaries.${pname} or null
            texliveBinaries.core-big.${outName} or null ]
          ++ (args.extraBuildInputs or [ ]) ++ [ bash perl ]
          ++ (lib.attrVals (args.scriptExts or [ ]) extToInput);
        nativeBuildInputs = extraNativeBuildInputs;
        # absolute scripts folder
        scriptsFolder = lib.optionalString (run ? outPath) (run.outPath + "/scripts/" + args.scriptsFolder or pname);
        # binaries info
        inherit (args) binfiles;
        binlinks = builtins.attrNames (args.binlinks or { });
        bintargets = builtins.attrValues (args.binlinks or { });
        # build scripts
        patchScripts = ./patch-scripts.sed;
        makeBinContainers = ./make-bin-containers.sh;
      }
      ''
        . "$makeBinContainers"
        ${args.postFixup or ""}
      ''
  );
in
{ pkgs = tex ++ doc ++ source ++ tlpkg ++ bin; }
