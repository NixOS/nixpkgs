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
, extraRevision ? ""
, extraVersion ? ""
, sha512
, mirrors
, fixedHashes ? { }
, postUnpack ? ""
, stripPrefix ? 1
, license ? [ ]
, hasHyphens ? false
, hasInfo ? false
, hasManpages ? false
, hasRunfiles ? false
, hasTlpkg ? false
, ...
}@args:

/* buildTeXLivePackage converts an attribute set extracted from tlpdb.nix (with
  the deps attribute already processed) to a fake multi-output derivation with
  possible outputs [ "tex" "texdoc" "texsource" "tlpkg" "out" "man" "info" ]
*/

let
  # common metadata
  name = "${pname}-${version}${extraVersion}";
  meta = {
    license = map (x: lib.licenses.${x}) license;
    # TeX Live packages should not be installed directly into the user profile
    outputsToInstall = [ ];
  };
  # emulate the outputSpecified attribute
  specifyOutput = { meta = meta // { outputSpecified = true; }; };

  hasBinfiles = args ? binfiles && args.binfiles != [ ];
  hasDocfiles = sha512 ? doc;
  hasSource = sha512 ? source;

  # emulate drv.all, drv.outputs lists
  all = lib.optional hasRunfiles tex ++
    lib.optional hasDocfiles texdoc ++
    lib.optional hasSource texsource ++
    lib.optional hasTlpkg tlpkg ++
    lib.optional hasBinfiles out ++
    lib.optional hasManpages man ++
    lib.optional hasInfo info;
  outputs = lib.catAttrs "tlOutputName" all;

  # emulate legacy drv.pkgs interface
  pkgs = [ (tex // { tlType = "run"; }) ] ++
    lib.optional hasDocfiles (texdoc // { tlType = "doc"; inherit hasManpages; }) ++
    lib.optional hasSource (texsource // { tlType = "source"; }) ++
    lib.optional hasTlpkg (tlpkg // { tlType = "tlpkg"; }) ++
    lib.optional hasBinfiles (out // { tlType = "bin"; });

  # emulate multi-output derivation plus additional metadata
  # (out is handled in mkContainer)
  passthru = {
    inherit all outputs pname pkgs;
    revision = toString revision + extraRevision;
    version = version + extraVersion;
    tex = tex // specifyOutput;
  } // lib.optionalAttrs (args ? deps) { tlDeps = args.deps; }
  // lib.optionalAttrs (args ? formats) { inherit (args) formats; }
  // lib.optionalAttrs hasHyphens { inherit hasHyphens; }
  // lib.optionalAttrs (args ? postactionScript) { inherit (args) postactionScript; }
  // lib.optionalAttrs hasDocfiles { texdoc = texdoc // specifyOutput; }
  // lib.optionalAttrs hasSource { texsource = texsource // specifyOutput; }
  // lib.optionalAttrs hasTlpkg { tlpkg = tlpkg // specifyOutput; }
  // lib.optionalAttrs hasManpages { man = man // specifyOutput; }
  // lib.optionalAttrs hasInfo { info = info // specifyOutput; };

  # build run, doc, source, tlpkg containers
  mkContainer = tlType: tlOutputName: sha512:
    let
      fixedHash = fixedHashes.${tlType} or null; # be graceful about missing hashes
      # the basename used by upstream (without ".tar.xz" suffix)
      # tlpkg is not a true container but a subfolder of the run container
      urlName = pname + (lib.optionalString (tlType != "run" && tlType != "tlpkg") ".${tlType}");
      urls = map (up: "${up}/archive/${urlName}.r${toString revision}.tar.xz") mirrors;
    in
    builtins.removeAttrs
      (runCommand "${name}-${tlOutputName}"
        ({
          src = fetchurl { inherit urls sha512; };
          # overriding outputName breaks the build,
          # so save its value in tlOutputName
          inherit meta passthru stripPrefix tlOutputName;
        } // lib.optionalAttrs (fixedHash != null) {
          outputHash = fixedHash;
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        })
        (''
          mkdir "$out"
          case "$tlOutputName" in
            tlpkg) tar -xf "$src" --strip-components=1 \
                -C "$out" --anchored --exclude=tlpkg/tlpobj --exclude=tlpkg/installer --exclude=tlpkg/gpg --keep-old-files \
                tlpkg ;;
            *) tar -xf "$src" --strip-components="$stripPrefix" \
                -C "$out" --anchored --exclude=tlpkg --keep-old-files ;;
          esac
        '' + postUnpack))
      # remove the standard drv.out, optionally replace it with the bin container
      [ "out" ] // lib.optionalAttrs hasBinfiles { out = out // specifyOutput; };

  tex =
    if hasRunfiles then mkContainer "run" "tex" sha512.run
    else passthru
      // { inherit meta; tlOutputName = "tex"; }
      // lib.optionalAttrs hasBinfiles { out = out // specifyOutput; };

  texdoc = mkContainer "doc" "texdoc" sha512.doc;

  texsource = mkContainer "source" "texsource" sha512.source;

  tlpkg = mkContainer "tlpkg" "tlpkg" sha512.run;

  # build binary containers
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

  out = runCommand "${name}"
    {
      passthru = passthru // { tlOutputName = "out"; };
      inherit meta;
      tex = lib.optionalString hasRunfiles tex.outPath;
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
      ${args.postFixup or ""}
    '';

  # build man, info containers
  man = runCommand "${name}-man" { inherit texdoc; passthru.lOutputName = "man"; }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/man
    '';

  info = runCommand "${name}-info" { inherit texdoc; passthru.tlOutputName = "info"; }
    ''
      mkdir -p "$out"/share
      ln -s {"$texdoc"/doc,"$out"/share}/info
    '';
in
tex
