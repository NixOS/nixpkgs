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
  all = lib.optional hasBinfiles out ++
    lib.optional hasRunfiles tex ++
    lib.optional hasDocfiles texdoc ++
    lib.optional hasSource texsource ++
    lib.optional hasTlpkg tlpkg ++
    lib.optional hasManpages man ++
    lib.optional hasInfo info;
  outputs = lib.catAttrs "tlOutputName" all;

  # texlive.combine compatibility layer
  # TODO move to upper level
  pkgs = [ tex ] ++
    lib.optional hasDocfiles (texdoc // { inherit hasManpages; }) ++
    lib.optional hasSource texsource ++
    lib.optional hasTlpkg tlpkg ++
    lib.optional hasBinfiles out;

  # emulate multi-output derivation plus additional metadata
  # (out is handled in mkContainer)
  passthru = {
    inherit all outputs pname pkgs;
    revision = toString revision + extraRevision;
    version = version + extraVersion;
    outputSpecified = true;
    inherit tex;
  } // lib.optionalAttrs (args ? deps) { tlDeps = args.deps; }
  // lib.optionalAttrs (args ? formats) { inherit (args) formats; }
  // lib.optionalAttrs hasHyphens { inherit hasHyphens; }
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
      # TODO switch to simpler "${name}-${tlOutputName}" (requires new fixed hashes)
      container = runCommand "texlive-${pname}${lib.optionalString (tlType != "run") ".${tlType}"}-${version}${extraVersion}"
        ({
          src = fetchurl { inherit urls sha512; };
          # save outputName as fixed output derivations cannot change nor override outputName
          passthru = passthru // { inherit tlOutputName; };
          # TODO move tlType to compatibility layer (requires a rebuild)
          inherit meta stripPrefix tlType;
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
    in
    # remove the standard drv.out, optionally replace it with the bin container
    builtins.removeAttrs container [ "out" ] // lib.optionalAttrs hasBinfiles { inherit out; };

  tex =
    if hasRunfiles then mkContainer "run" "tex" sha512.run
    else passthru
      # TODO move tlType to compatibility layer (requires a rebuild)
      // { inherit meta; tlOutputName = "tex"; tlType = "run"; }
      // lib.optionalAttrs hasBinfiles { inherit out; };

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

  # TODO switch to simpler "${name}" (requires a rebuild)
  out = runCommand "texlive-${pname}.bin-${version}"
    {
      inherit meta;
      # TODO move tlType to compatibility layer
      passthru = passthru // { tlOutputName = "out"; tlType = "bin"; };
      # shebang interpreters
      buildInputs = (args.extraBuildInputs or [ ]) ++ [ bash perl ] ++ (lib.attrVals (args.scriptExts or [ ]) extToInput);
      # absolute scripts folder
      scriptsFolder = lib.optionalString (tex ? outPath) (tex.outPath + "/scripts/" + args.scriptsFolder or pname);
      # binaries info
      inherit (args) binfiles;
      binlinks = builtins.attrNames (args.binlinks or { });
      bintargets = builtins.attrValues (args.binlinks or { });
      binfolders = [ (lib.getBin texliveBinaries.core) ] ++
        lib.optional (texliveBinaries ? ${pname}) (lib.getBin texliveBinaries.${pname});
      # build scripts
      patchScripts = ./patch-scripts.sed;
      makeBinContainers = ./make-bin-containers.sh;
    }
    ''
      . "$makeBinContainers"
      ${postFixup}
    '';

  # build man, info containers
  # TODO switch to simpler "${name}-man" (requires a rebuild)
  man = runCommand "texlive-${pname}.man-${version}${extraVersion}"
    {
      inherit meta texdoc;
      passthru = passthru // { tlOutputName = "man"; };
    }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/man
    '';

  # TODO switch to simpler "${name}-info" (requires a rebuild)
  info = runCommand "texlive-${pname}.info-${version}${extraVersion}"
    {
      inherit meta texdoc;
      passthru = passthru // { tlOutputName = "info"; };
    }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/info
    '';
in
builtins.removeAttrs (if hasBinfiles then out else tex) [ "outputSpecified" ]
