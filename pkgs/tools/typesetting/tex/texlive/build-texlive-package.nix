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

/* Convert an attribute set extracted from tlpdb.nix (with the deps attribute
  already processed) to a fake multi-output derivation with possible outputs
  [ "tex" "texdoc" "texsource" "tlpkg" "out" "man" "info" ]
*/

# TODO stabilise a generic interface decoupled from the finer details of the
# translation from texlive.tlpdb to tlpdb.nix
{ pname
, revision
, version ? toString revision
, extraRevision ? ""
, extraVersion ? ""
, sha512
, mirrors
, fixedHashes ? { }
, postUnpack ? ""
, postFixup ? ""
, stripPrefix ? 1
, license ? [ ]
, hasHyphens ? false
, hasInfo ? false
, hasManpages ? false
, hasRunfiles ? false
, hasTlpkg ? false
, extraNativeBuildInputs ? [ ]
, ...
}@args:

let
  # common metadata
  name = "${pname}-${version}${extraVersion}";
  meta = {
    license = map (x: lib.licenses.${x}) license;
    # TeX Live packages should not be installed directly into the user profile
    outputsToInstall = [ ];
  };

  hasBinfiles = args ? binfiles && args.binfiles != [ ];
  hasDocfiles = sha512 ? doc;
  hasSource = sha512 ? source;

  # emulate drv.all, drv.outputs lists
  all = lib.optional hasBinfiles bin ++
    lib.optional hasRunfiles tex ++
    lib.optional hasDocfiles texdoc ++
    lib.optional hasSource texsource ++
    lib.optional hasTlpkg tlpkg ++
    lib.optional hasManpages man ++
    lib.optional hasInfo info;
  outputs = lib.catAttrs "tlOutputName" all;

  mainDrv = if hasBinfiles then bin
    else if hasRunfiles then tex
    else if hasTlpkg then tlpkg
    else if hasDocfiles then texdoc
    else if hasSource then texsource
    else tex; # fall back to attrset tex if there is no derivation

  # emulate multi-output derivation plus additional metadata
  # (out is handled in mkContainer)
  passthru = {
    inherit all outputs pname;
    revision = toString revision + extraRevision;
    version = version + extraVersion;
    outputSpecified = true;
    inherit tex;
  } // lib.optionalAttrs (args ? deps) { tlDeps = args.deps; }
  // lib.optionalAttrs (args ? fontMaps) { inherit (args) fontMaps; }
  // lib.optionalAttrs (args ? formats) { inherit (args) formats; }
  // lib.optionalAttrs (args ? hyphenPatterns) { inherit (args) hyphenPatterns; }
  // lib.optionalAttrs (args ? postactionScript) { inherit (args) postactionScript; }
  // lib.optionalAttrs hasDocfiles { texdoc = texdoc; }
  // lib.optionalAttrs hasSource { texsource = texsource; }
  // lib.optionalAttrs hasTlpkg { tlpkg = tlpkg; }
  // lib.optionalAttrs hasManpages { man = man; }
  // lib.optionalAttrs hasInfo { info = info; };

  # build run, doc, source, tlpkg containers
  mkContainer = tlType: tlOutputName: sha512:
    let
      fixedHash = fixedHashes.${tlType} or null; # be graceful about missing hashes
      # the basename used by upstream (without ".tar.xz" suffix)
      # tlpkg is not a true container but a subfolder of the run container
      urlName = pname + (lib.optionalString (tlType != "run" && tlType != "tlpkg") ".${tlType}");
      urls = map (up: "${up}/archive/${urlName}.r${toString revision}.tar.xz") mirrors;
      container = runCommand "${name}-${tlOutputName}"
        ({
          src = fetchurl { inherit urls sha512; };
          inherit passthru;
          # save outputName, since fixed output derivations cannot change nor override outputName
          inherit meta stripPrefix tlOutputName;
        } // lib.optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        })
        (''
          mkdir "$out"
          if [[ "$tlOutputName"  == "tlpkg" ]]; then
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
    in
    # remove the standard drv.out, optionally replace it with the bin container
    builtins.removeAttrs container [ "out" ] // lib.optionalAttrs hasBinfiles { out = bin; };

  tex =
    if hasRunfiles then mkContainer "run" "tex" sha512.run
    else passthru
      // { inherit meta; tlOutputName = "tex"; }
      // lib.optionalAttrs hasBinfiles { out = bin; };

  texdoc = mkContainer "doc" "texdoc" sha512.doc;

  texsource = mkContainer "source" "texsource" sha512.source;

  tlpkg = mkContainer "tlpkg" "tlpkg" sha512.run;

  # build bin container
  extToInput = {
    # find interpreters for the script extensions found in tlpdb
    jar = jdk;
    lua = texliveBinaries.luatex;
    py = python3;
    rb = ruby;
    sno = snobol4;
    tcl = tk;
    texlua = texliveBinaries.luatex;
    tlu = texliveBinaries.luatex;
  };

  bin = runCommand "${name}"
    {
      inherit meta;
      passthru = passthru // { tlOutputName = "out"; };
      # shebang interpreters
      buildInputs =let outName = builtins.replaceStrings [ "-" ] [ "_" ] pname; in
        [ texliveBinaries.core.${outName} or null
          texliveBinaries.${pname} or null
          texliveBinaries.core-big.${outName} or null ]
        ++ (args.extraBuildInputs or [ ]) ++ [ bash perl ]
        ++ (lib.attrVals (args.scriptExts or [ ]) extToInput);
      nativeBuildInputs = extraNativeBuildInputs;
      # absolute scripts folder
      scriptsFolder = lib.optionals (tex ? outPath) (builtins.map (f: tex.outPath + "/scripts/" + f) (lib.toList args.scriptsFolder or pname));
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
    '';

  # build man, info containers
  man = builtins.removeAttrs (runCommand "${name}-man"
    {
      inherit meta texdoc;
      passthru = passthru // { tlOutputName = "man"; };
    }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/man
    '') [ "out" ] // lib.optionalAttrs hasBinfiles { out = bin; };

  info = builtins.removeAttrs (runCommand "${name}-info"
    {
      inherit meta texdoc;
      passthru = passthru // { tlOutputName = "info"; };
    }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/info
    '') [ "out" ] // lib.optionalAttrs hasBinfiles { out = bin; };
in
builtins.removeAttrs mainDrv [ "outputSpecified" ]
