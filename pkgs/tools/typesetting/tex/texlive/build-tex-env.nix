{
  # texlive package set
  tl
, bin

, lib
, buildEnv
, libfaketime
, makeFontsConf
, makeWrapper
, runCommand
, writeShellScript
, writeText
, toTLPkgSets
, bash
, perl

  # common runtime dependencies
, coreutils
, gawk
, gnugrep
, gnused
, ghostscript
}:

lib.fix (self: {
  withDocs ? false
, withSources ? false
, requiredTeXPackages ? ps: [ ps.scheme-infraonly ]

### texlive.combine backward compatibility
, __extraName ? "combined"
, __extraVersion ? ""
# emulate the old texlive.combine (e.g. add man pages to main output)
, __combine ? false
# adjust behavior further if called from the texlive.combine wrapper
, __fromCombineWrapper ? false
# build only the formats of a package (for internal use!)
, __formatsOf ? null
}@args:

let
  ### buildEnv with custom attributes
  buildEnv' = args: (buildEnv
    ({ inherit (args) name paths; })
      // lib.optionalAttrs (args ? extraOutputsToInstall) { inherit (args) extraOutputsToInstall; })
    .overrideAttrs (removeAttrs args [ "extraOutputsToInstall" "name" "paths" "pkgs" ]);

  ### texlive.combine backward compatibility
  # if necessary, convert old style { pkgs = [ ... ]; } packages to attribute sets
  isOldPkgList = p: ! p.outputSpecified or false && p ? pkgs && builtins.all (p: p ? tlType) p.pkgs;
  ensurePkgSets = ps: if ! __fromCombineWrapper && builtins.any isOldPkgList ps
    then let oldPkgLists = builtins.partition isOldPkgList ps;
      in oldPkgLists.wrong ++ lib.concatMap toTLPkgSets oldPkgLists.right
    else ps;

  pkgList = rec {
    # resolve dependencies of the packages that affect the runtime
    all =
      let
        # order of packages is irrelevant
        packages = builtins.sort (a: b: a.pname < b.pname) (ensurePkgSets (requiredTeXPackages tl));
        runtime = builtins.partition
          (p: p.outputSpecified or false -> builtins.elem (p.tlOutputName or p.outputName) [ "out" "tex" "tlpkg" ])
          packages;
        keySet = p: {
          key = ((p.name or "${p.pname}-${p.version}") + "-" + p.tlOutputName or p.outputName or "");
          inherit p;
          tlDeps = if p ? tlDeps then ensurePkgSets p.tlDeps else (p.requiredTeXPackages or (_: [ ]) tl);
        };
      in
      # texlive.combine: the wrapper already resolves all dependencies
      if __fromCombineWrapper then requiredTeXPackages null else
        builtins.catAttrs "p" (builtins.genericClosure {
          startSet = map keySet runtime.right;
          operator = p: map keySet p.tlDeps;
        }) ++ runtime.wrong;

    # group the specified outputs
    specified = builtins.partition (p: p.outputSpecified or false) all;
    specifiedOutputs = lib.groupBy (p: p.tlOutputName or p.outputName) specified.right;
    otherOutputNames = builtins.catAttrs "key" (builtins.genericClosure {
      startSet = map (key: { inherit key; }) (lib.concatLists (builtins.catAttrs "outputs" specified.wrong));
      operator = _: [ ];
    });
    otherOutputs = lib.genAttrs otherOutputNames (n: builtins.catAttrs n specified.wrong);
    outputsToInstall = builtins.catAttrs "key" (builtins.genericClosure {
      startSet = map (key: { inherit key; })
        ([ "out" ] ++ lib.optional (otherOutputs ? man) "man"
          ++ lib.concatLists (builtins.catAttrs "outputsToInstall" (builtins.catAttrs "meta" specified.wrong)));
      operator = _: [ ];
    });

    # split binary and tlpkg from tex, texdoc, texsource
    bin = if __fromCombineWrapper
      then builtins.filter (p: p.tlType == "bin") all # texlive.combine: legacy filter
      else otherOutputs.out or [ ] ++ specifiedOutputs.out or [ ];
    tlpkg = if __fromCombineWrapper
      then builtins.filter (p: p.tlType == "tlpkg") all # texlive.combine: legacy filter
      else otherOutputs.tlpkg or [ ] ++ specifiedOutputs.tlpkg or [ ];

    nonbin = if __fromCombineWrapper then builtins.filter (p: p.tlType != "bin" && p.tlType != "tlpkg") all # texlive.combine: legacy filter
      else (if __combine then # texlive.combine: emulate old input ordering to avoid rebuilds
        lib.concatMap (p: lib.optional (p ? tex) p.tex
          ++ lib.optional ((withDocs || p ? man) && p ? texdoc) p.texdoc
          ++ lib.optional (withSources && p ? texsource) p.texsource) specified.wrong
        else otherOutputs.tex or [ ]
          ++ lib.optionals withDocs (otherOutputs.texdoc or [ ])
          ++ lib.optionals withSources (otherOutputs.texsource or [ ]))
        ++ specifiedOutputs.tex or [ ] ++ specifiedOutputs.texdoc or [ ] ++ specifiedOutputs.texsource or [ ];

    # outputs that do not become part of the environment
    nonEnvOutputs = lib.subtractLists [ "out" "tex" "texdoc" "texsource" "tlpkg" ] otherOutputNames;

    # packages that contribute to config files and formats
    fontMaps = lib.filter (p: p ? fontMaps && (p.tlOutputName or p.outputName == "tex")) nonbin;
    sortedFontMaps = builtins.sort (a: b: a.pname < b.pname) fontMaps;
    hyphenPatterns = lib.filter (p: p ? hyphenPatterns && (p.tlOutputName or p.outputName == "tex")) nonbin;
    sortedHyphenPatterns = builtins.sort (a: b: a.pname < b.pname) hyphenPatterns;
    formatPkgs = lib.filter (p: p ? formats && (p.outputSpecified or false -> p.tlOutputName or p.outputName == "tex") && builtins.any (f: f.enabled or true) p.formats) all;
    sortedFormatPkgs = if __formatsOf != null then [ __formatsOf ] else builtins.sort (a: b: a.pname < b.pname) formatPkgs;
    formats = map (p: self { requiredTeXPackages = ps: [ ps.scheme-infraonly p ] ++ hyphenPatterns; __formatsOf = p; }) sortedFormatPkgs;
  };

  # list generated by inspecting `grep -IR '\([^a-zA-Z]\|^\)gs\( \|$\|"\)' "$TEXMFDIST"/scripts`
  # and `grep -IR rungs "$TEXMFDIST"`
  # and ignoring luatex, perl, and shell scripts (those must be patched using postFixup)
  needsGhostscript = lib.any (p: lib.elem p.pname [ "context" "dvipdfmx" "latex-papersize" "lyluatex" ]) pkgList.bin;

  name = if __combine then "texlive-${__extraName}-${bin.texliveYear}${__extraVersion}" # texlive.combine: old name name
    else "texlive-${bin.texliveYear}-" + (if __formatsOf != null then "${__formatsOf.pname}-fmt" else "env");

  texmfdist = buildEnv' {
    name = "${name}-texmfdist";

    # remove fake derivations (without 'outPath') to avoid undesired build dependencies
    paths = builtins.catAttrs "outPath" pkgList.nonbin;

    # mktexlsr
    nativeBuildInputs = [ tl."texlive.infra" ];

    postBuild = # generate ls-R database
    ''
      mktexlsr "$out"
    '';
  };

  tlpkg = buildEnv {
    name = "${name}-tlpkg";

    # remove fake derivations (without 'outPath') to avoid undesired build dependencies
    paths = builtins.catAttrs "outPath" pkgList.tlpkg;
  };

  # the 'non-relocated' packages must live in $TEXMFROOT/texmf-dist
  # and sometimes look into $TEXMFROOT/tlpkg (notably fmtutil, updmap look for perl modules in both)
  texmfroot = runCommand "${name}-texmfroot" {
    inherit texmfdist tlpkg;
  } ''
    mkdir -p "$out"
    ln -s "$texmfdist" "$out"/texmf-dist
    ln -s "$tlpkg" "$out"/tlpkg
  '';

  # texlive.combine: expose info and man pages in usual /share/{info,man} location
  doc = buildEnv {
    name = "${name}-doc";

    paths = [ (texmfdist.outPath + "/doc") ];
    extraPrefix = "/share";

    pathsToLink = [
      "/info"
      "/man"
    ];
  };

  meta = {
    description = "TeX Live environment"
      + lib.optionalString withDocs " with documentation"
      + lib.optionalString (withDocs && withSources) " and"
      + lib.optionalString withSources " with sources";
    platforms = lib.platforms.all;
    longDescription = "Contains the following packages and their transitive dependencies:\n - "
      + lib.concatMapStringsSep "\n - "
          (p: p.pname + (lib.optionalString (p.outputSpecified or false) " (${p.tlOutputName or p.outputName})"))
          (requiredTeXPackages tl);
  };

  # other outputs
  nonEnvOutputs = lib.genAttrs pkgList.nonEnvOutputs (outName: buildEnv' {
    inherit name;
    outputs = [ outName ];
    paths = builtins.catAttrs "outPath"
      (pkgList.otherOutputs.${outName} or [ ] ++ pkgList.specifiedOutputs.${outName} or [ ]);
    # force the output to be ${outName} or nix-env will not work
    nativeBuildInputs = [ (writeShellScript "force-output.sh" ''
      export out="''${${outName}-}"
    '') ];
    inherit meta passthru;
  });

  passthru = {
    # This is set primarily to help find-tarballs.nix to do its job
    requiredTeXPackages = builtins.filter lib.isDerivation (pkgList.bin ++ pkgList.nonbin
      ++ lib.optionals (! __fromCombineWrapper)
        (lib.concatMap (n: (pkgList.otherOutputs.${n} or [ ] ++ pkgList.specifiedOutputs.${n} or [ ]))) pkgList.nonEnvOutputs);
    # useful for inclusion in the `fonts.packages` nixos option or for use in devshells
    fonts = "${texmfroot}/texmf-dist/fonts";
    # support variants attrs, (prev: attrs)
    __overrideTeXConfig = newArgs:
      let appliedArgs = if builtins.isFunction newArgs then newArgs args else newArgs; in
        self (args // { __fromCombineWrapper = false; } // appliedArgs);
    withPackages = reqs: self (args // { requiredTeXPackages = ps: requiredTeXPackages ps ++ reqs ps; __fromCombineWrapper = false; });
  };

  # TeXLive::TLOBJ::fmtutil_cnf_lines
  fmtutilLine = { name, engine, enabled ? true, patterns ? [ "-" ], options ? "", ... }:
    lib.optionalString (! enabled) "#! " + "${name} ${engine} ${lib.concatStringsSep "," patterns} ${options}";
  fmtutilLines = { pname, formats, ...}:
    [ "#" "# from ${pname}:" ] ++ map fmtutilLine formats;

  # TeXLive::TLOBJ::language_dat_lines
  langDatLine = { name, file, synonyms ? [ ], ... }:
    [ "${name} ${file}" ] ++ map (s: "=" + s) synonyms;
  langDatLines = { pname, hyphenPatterns, ... }:
    [ "% from ${pname}:" ] ++ builtins.concatMap langDatLine hyphenPatterns;

  # TeXLive::TLOBJ::language_def_lines
  # see TeXLive::TLUtils::parse_AddHyphen_line for default values
  langDefLine = { name, file, lefthyphenmin ? "", righthyphenmin ? "", synonyms ? [ ], ... }:
    map (n: "\\addlanguage{${n}}{${file}}{}{${if lefthyphenmin == "" then "2" else lefthyphenmin}}{${if righthyphenmin ==  "" then "3" else righthyphenmin}}")
    ([ name ] ++ synonyms);
  langDefLines = { pname, hyphenPatterns, ... }:
    [ "% from ${pname}:" ] ++ builtins.concatMap langDefLine hyphenPatterns;

  # TeXLive::TLOBJ::language_lua_lines
  # see TeXLive::TLUtils::parse_AddHyphen_line for default values
  langLuaLine = { name, file, lefthyphenmin ? "", righthyphenmin ? "", synonyms ? [ ], ... }@args: ''
      ''\t['${name}'] = {
      ''\t''\tloader = '${file}',
      ''\t''\tlefthyphenmin = ${if lefthyphenmin == "" then "2" else lefthyphenmin},
      ''\t''\trighthyphenmin = ${if righthyphenmin ==  "" then "3" else righthyphenmin},
      ''\t''\tsynonyms = { ${lib.concatStringsSep ", " (map (s: "'${s}'") synonyms)} },
    ''
    + lib.optionalString (args ? file_patterns) "\t\tpatterns = '${args.file_patterns}',\n"
    + lib.optionalString (args ? file_exceptions) "\t\thyphenation = '${args.file_exceptions}',\n"
    + lib.optionalString (args ? luaspecial) "\t\tspecial = '${args.luaspecial}',\n"
    + "\t},";
  langLuaLines = { pname, hyphenPatterns, ... }:
    [ "-- from ${pname}:" ] ++ map langLuaLine hyphenPatterns;

  assembleConfigLines = f: packages:
    builtins.concatStringsSep "\n" (builtins.concatMap f packages);

  updmapLines = { pname, fontMaps, ...}:
    [ "# from ${pname}:" ] ++ fontMaps;

  out =
# no indent for git diff purposes
buildEnv' {

  inherit name;

  # use attrNames, attrValues to ensure the two lists are sorted in the same way
  outputs = [ "out" ] ++ lib.optionals (! __combine && __formatsOf == null) (builtins.attrNames nonEnvOutputs);
  otherOutputs = lib.optionals (! __combine && __formatsOf == null) (builtins.attrValues nonEnvOutputs);

  # remove fake derivations (without 'outPath') to avoid undesired build dependencies
  paths = builtins.catAttrs "outPath" pkgList.bin ++ lib.optionals (! __combine && __formatsOf == null) pkgList.formats
    ++ lib.optional __combine doc;
  pathsToLink = [
    "/"
    "/share/texmf-var/scripts"
    "/share/texmf-var/tex/generic/config"
    "/share/texmf-var/web2c"
    "/share/texmf-config"
    "/bin" # ensure these are writeable directories
  ];

  nativeBuildInputs = [
    makeWrapper
    libfaketime
    tl."texlive.infra" # mktexlsr
    tl.texlive-scripts # fmtutil, updmap
    tl.texlive-scripts-extra # texlinks
    perl
  ];

  buildInputs = [ coreutils gawk gnugrep gnused ] ++ lib.optional needsGhostscript ghostscript;

  inherit meta passthru __combine;
  __formatsOf = __formatsOf.pname or null;

  inherit texmfdist texmfroot;

  fontconfigFile = makeFontsConf { fontDirectories = [ "${texmfroot}/texmf-dist/fonts" ]; };

  fmtutilCnf = assembleConfigLines fmtutilLines pkgList.sortedFormatPkgs;
  updmapCfg = assembleConfigLines updmapLines pkgList.sortedFontMaps;

  languageDat = assembleConfigLines langDatLines pkgList.sortedHyphenPatterns;
  languageDef = assembleConfigLines langDefLines pkgList.sortedHyphenPatterns;
  languageLua = assembleConfigLines langLuaLines pkgList.sortedHyphenPatterns;

  postactionScripts = builtins.catAttrs "postactionScript" pkgList.tlpkg;

  postBuild = ''
    . "${./build-tex-env.sh}"
  '';

  allowSubstitutes = true;
  preferLocalBuild = false;
};
  # outputsToInstall must be set *after* overrideAttrs (used in buildEnv') or it fails the checkMeta tests
in if __combine || __formatsOf != null then out else lib.addMetaAttrs { inherit (pkgList) outputsToInstall; } out)
