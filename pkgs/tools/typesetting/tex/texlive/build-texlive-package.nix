{ lib
, fetchurl
, runCommand
, writeShellScript

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

  The multi-output is emulated as follows:
  - the main derivation is a multi-output derivation that builds links to the
    containers (tex, texdoc, ...)
  - the output attributes are replaced with the actual containers with the
    outputSpecified attribute set to true

  In this way, when texlive.withPackages picks an output such as drv.tex, it
  receives the actual container, avoiding superfluous dependencies on the other
  containers (for instance doc containers).
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
    longDescription = ''
      This package cannot be installed directly. Please use `texlive.withPackages`.
    '';
    # discourage nix-env from matching this package
    priority = 10;
  } // lib.optionalAttrs (args ? shortdesc) {
    description = args.shortdesc;
  };

  hasBinfiles = args ? binfiles && args.binfiles != [ ];
  hasDocfiles = sha512 ? doc;
  hasSource = sha512 ? source;

  # containers that will be built by Hydra
  outputs = lib.optional hasBinfiles "out" ++
    lib.optional hasRunfiles "tex" ++
    lib.optional hasDocfiles "texdoc" ++
    # omit building sources, since as far as we know, installing them is not common
    # the sources will still be available under drv.texsource
    # lib.optional hasSource "texsource" ++
    lib.optional hasTlpkg "tlpkg" ++
    lib.optional hasManpages "man" ++
    lib.optional hasInfo "info";
  outputDrvs = lib.getAttrs outputs containers;

  passthru = {
    # metadata
    inherit pname;
    revision = toString revision + extraRevision;
    version = version + extraVersion;
    # containers behave like specified outputs
    outputSpecified = true;
  } // lib.optionalAttrs (args ? deps) { tlDeps = args.deps; }
  // lib.optionalAttrs (args ? fontMaps) { inherit (args) fontMaps; }
  // lib.optionalAttrs (args ? formats) { inherit (args) formats; }
  // lib.optionalAttrs (args ? hyphenPatterns) { inherit (args) hyphenPatterns; }
  // lib.optionalAttrs (args ? postactionScript) { inherit (args) postactionScript; }
  // lib.optionalAttrs hasSource { inherit (containers) texsource; }
  // lib.optionalAttrs (! hasRunfiles) { tex = fakeTeX; };

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
    # remove drv.out to avoid confusing texlive.withPackages
    removeAttrs container [ "out" ]
    // outputDrvs;

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

  # fake derivation for resolving dependencies in the absence of a "tex" containers
  fakeTeX = passthru
    // { inherit meta; tlOutputName = "tex"; }
    // outputDrvs;

  containers = rec {
    tex = mkContainer "run" "tex" sha512.run;
    texdoc = mkContainer "doc" "texdoc" sha512.doc;
    texsource = mkContainer "source" "texsource" sha512.source;
    tlpkg = mkContainer "tlpkg" "tlpkg" sha512.run;

    # bin container
    out = runCommand "${name}"
      {
        inherit meta;
        passthru = passthru // { tlOutputName = "out"; };
        # shebang interpreters
        buildInputs = let outName = builtins.replaceStrings [ "-" ] [ "_" ] pname; in
          [
            texliveBinaries.core.${outName} or null
            texliveBinaries.${pname} or null
            texliveBinaries.core-big.${outName} or null
          ]
          ++ (args.extraBuildInputs or [ ]) ++ [ bash perl ]
          ++ (lib.attrVals (args.scriptExts or [ ]) extToInput);
        nativeBuildInputs = extraNativeBuildInputs;
        # absolute scripts folder
        scriptsFolder = lib.optionals (hasRunfiles && tex ? outPath) (map (f: tex.outPath + "/scripts/" + f) (lib.toList args.scriptsFolder or pname));
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
      '' // outputDrvs;

    # build man, info containers
    man = removeAttrs
      (runCommand "${name}-man"
        {
          inherit meta texdoc;
          passthru = passthru // { tlOutputName = "man"; };
        }
        ''
          mkdir -p "$out"/share
          ln -s {"$texdoc"/doc,"$out"/share}/man
        '') [ "out" ] // outputDrvs;

    info = removeAttrs
      (runCommand "${name}-info"
        {
          inherit meta texdoc;
          passthru = passthru // { tlOutputName = "info"; };
        }
        ''
          mkdir -p "$out"/share
          ln -s {"$texdoc"/doc,"$out"/share}/info
        '') [ "out" ] // outputDrvs;
  };
in
if outputs == [ ] then removeAttrs fakeTeX [ "outputSpecified" ] else
runCommand name
  {
    __structuredAttrs = true;
    inherit meta outputDrvs outputs;
    passthru = removeAttrs passthru [ "outputSpecified" ];

    # force output name in case "out" is missing
    nativeBuildInputs = lib.optional (! hasBinfiles)
      (writeShellScript "force-output.sh" ''
        export out="''${${builtins.head outputs}-}"
      '');
  }
  ''
    for outputName in ''${!outputs[@]} ; do
      ln -s "''${outputDrvs[$outputName]}" "''${outputs[$outputName]}"
    done
  '' // outputDrvs
