{
  # texlive package set
  tl
, bin

, stdenvNoCC
, lib
, buildEnv
, libfaketime
, makeFontsConf
, makeWrapper
, runCommand
, toTLPkgSets
, perl

  # common runtime dependencies
, coreutils
, gawk
, gnugrep
, gnused
, ghostscript
}:

# the defaults listed here are not used!
lib.fix (self: {
  requiredTeXPackages ? ps: [ ps.scheme-infraonly ]

### texlive.combine backward compatibility
, __extraName ? "combined"
, __extraVersion ? ""
# emulate the old texlive.combine (e.g. add man pages to main output)
, __combine ? false
# adjust behavior further if called from the texlive.combine wrapper
, __fromCombineWrapper ? false


, __formatsOf ? null
}@args:

stdenvNoCC.mkDerivation (finalAttrs:
let

  withDocs = finalAttrs.withDocs;
  withSources = finalAttrs.withSources;
  requiredTeXPackages = finalAttrs.passthru.requiredTeXPackages;

  __formatsOf = finalAttrs.passthru.__formatsOf;

  __combine = finalAttrs.__combine;
  __fromCombineWrapper = finalAttrs.__fromCombineWrapper;
  __extraName = finalAttrs.__extraName;
  __extraVersion = finalAttrs.__extraVersion;

  finalPackage = finalAttrs.finalPackage;

  ### simplified buildEnv with custom attributes and no outputSpecified logic
  buildEnvCommand = (buildEnv { name = ""; paths = [ ]; }).buildCommand;

  buildEnv' = { paths, pathsToLink ? [ "/" ], extraPrefix ? "", ... }@args: stdenvNoCC.mkDerivation (args // rec {
    ignoreCollisions = false;
    checkCollisionContents = true;
    inherit pathsToLink extraPrefix;
    nativeBuildInputs = [ perl ] ++ args.nativeBuildInputs or [ ];
    pkgs = builtins.toJSON (
      map (drv: {
        paths = [ drv ];
        priority = drv.meta.priority or 5;
      }) paths
    );
    # XXX: The size is somewhat arbitrary
    passAsFile = if builtins.stringLength pkgs >= 128 * 1024 then [ "pkgs" ] else [ ];
    buildCommand = buildEnvCommand;
  });

  ### texlive.combine backward compatibility
  # if necessary, convert old style { pkgs = [ ... ]; } packages to attribute sets
  isOldPkgList = p: ! p.outputSpecified or false && p ? pkgs && builtins.all (p: p ? tlType) p.pkgs;
  ensurePkgSets = ps: if ! __fromCombineWrapper && builtins.any isOldPkgList ps
    then let oldPkgLists = builtins.partition isOldPkgList ps;
      in oldPkgLists.wrong ++ lib.concatMap toTLPkgSets oldPkgLists.right
    else ps;

  ### resolve TeX dependencies
  resolveTeXDeps = reqs:
    let
      # order of packages is irrelevant
      packages = builtins.sort (a: b: a.pname < b.pname) (ensurePkgSets (reqs tl));
      # resolve dependencies of the packages that affect the runtime
      runtime = builtins.partition
        (p: p.outputSpecified or false -> builtins.elem (p.tlOutputName or p.outputName) [ "out" "tex" "tlpkg" ])
        packages;
      keySet = p: {
        key = ((p.name or "${p.pname}-${p.version}") + "-" + p.tlOutputName or p.outputName or "");
        inherit p;
        tlDeps = if p ? tlDeps then ensurePkgSets p.tlDeps else (p.requiredTeXPackages or (_: [ ]) tl);
      };
    in
      builtins.catAttrs "p" (builtins.genericClosure {
        startSet = map keySet runtime.right;
        operator = p: map keySet p.tlDeps;
      }) ++ runtime.wrong;

  uniqueStrings = strings: builtins.catAttrs "key" (builtins.genericClosure {
    startSet = map (key: { inherit key; }) strings;
    operator = _: [ ];
  });

  pkgList = rec {
    # texlive.combine: the wrapper already resolves all dependencies
    all = if __fromCombineWrapper then requiredTeXPackages null else resolveTeXDeps requiredTeXPackages;

    # group the specified outputs
    specified = builtins.partition (p: p.outputSpecified or false) all;
    specifiedOutputs = lib.groupBy (p: p.tlOutputName or p.outputName) specified.right;
    otherOutputNames = uniqueStrings (lib.concatLists (builtins.catAttrs "outputs" specified.wrong));
    otherOutputs = lib.genAttrs otherOutputNames (n: builtins.catAttrs n specified.wrong);
    outputsToInstall = uniqueStrings ([ "out" ] ++ lib.optional (otherOutputs ? man) "man"
      ++ lib.concatLists (builtins.catAttrs "outputsToInstall" (builtins.catAttrs "meta" specified.wrong)));

    # split binary and tlpkg from tex, texdoc, texsource
    bin = if __fromCombineWrapper
      then builtins.filter (p: p.tlType == "bin") all # texlive.combine: legacy filter
      else otherOutputs.out or [ ] ++ specifiedOutputs.out or [ ];
    tlpkg = if __fromCombineWrapper
      then builtins.filter (p: p.tlType == "tlpkg") all # texlive.combine: legacy filter
      else otherOutputs.tlpkg or [ ] ++ specifiedOutputs.tlpkg or [ ];

    nonbin = if __fromCombineWrapper then builtins.filter (p: p.tlType != "bin" && p.tlType != "tlpkg") all # texlive.combine: legacy filter
      else (otherOutputs.tex or [ ]
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
    formats = map (p: self {
      __formatsOf = p;
      requiredTeXPackages = ps: [ ps.scheme-infraonly p ] ++ hyphenPatterns;
    }) sortedFormatPkgs;
  };

  # list generated by inspecting `grep -IR '\([^a-zA-Z]\|^\)gs\( \|$\|"\)' "$TEXMFDIST"/scripts`
  # and `grep -IR rungs "$TEXMFDIST"`
  # and ignoring luatex, perl, and shell scripts (those must be patched using postFixup)
  needsGhostscript = lib.any (p: lib.elem p.pname [ "context" "dvipdfmx" "latex-papersize" "lyluatex" ]) pkgList.bin;

  # texlive.combine: expose info and man pages in usual /share/{info,man} location
  doc = buildEnv' {
    name = "${finalAttrs.name}-doc";

    paths = [ (finalAttrs.texmfdist.outPath + "/doc") ];
    extraPrefix = "/share";

    pathsToLink = [
      "/info"
      "/man"
    ];
  };

  # remove fake derivations (without 'outPath') to avoid undesired build dependencies
  paths = builtins.catAttrs "outPath" pkgList.bin ++ lib.optionals (! __combine && __formatsOf == null) pkgList.formats
    ++ lib.optional __combine doc;

  # other outputs
  nonEnvOutputs = lib.genAttrs pkgList.nonEnvOutputs (outName: buildEnv' {
    inherit (finalAttrs) name meta passthru;
    outputs = [ outName ];
    paths = builtins.catAttrs "outPath"
      (pkgList.otherOutputs.${outName} or [ ] ++ pkgList.specifiedOutputs.${outName} or [ ]);
    # force the output to be ${outName} or nix-env will not work
    preHook = ''
      export out="''${${outName}}"
    '';
  });

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

in
# no indent for git diff purposes
{
  withDocs = args.withDocs or false;
  withSources = args.withDocs or false;

  __extraName = args.__extraName or "combined";
  __extraVersion = args.__extraVersion or "";
  __combine = args.__combine or false;
  __fromCombineWrapper = args.__fromCombineWrapper or false;

  name = if __combine then "texlive-${__extraName}-${bin.texliveYear}${__extraVersion}" # texlive.combine: old name name
    else "texlive-${bin.texliveYear}-" + (if __formatsOf != null then "${__formatsOf.pname}-fmt" else "env");

  # use attrNames, attrValues to ensure the two lists are sorted in the same way
  outputs = [ "out" ] ++ lib.optionals (! __combine && __formatsOf == null) (builtins.attrNames nonEnvOutputs);
  otherOutputs = lib.optionals (! __combine && __formatsOf == null) (builtins.attrValues nonEnvOutputs);

  # buildEnv' arguments
  pathsToLink = [
    "/"
    "/share/texmf-var/scripts"
    "/share/texmf-var/tex/generic/config"
    "/share/texmf-var/web2c"
    "/share/texmf-config"
    "/bin" # ensure these are writeable directories
  ];

  ignoreCollisions = false;
  checkCollisionContents = true;
  extraPrefix = "";

  pkgs = builtins.toJSON (
      map (drv: {
        paths = [ drv ];
        priority = drv.meta.priority or 5;
      }) paths
    );

  # XXX: The size is somewhat arbitrary
  passAsFile = if builtins.stringLength finalAttrs.pkgs >= 128 * 1024 then [ "pkgs" ] else [ ];

  nativeBuildInputs = [
    makeWrapper
    libfaketime
    tl."texlive.infra" # mktexlsr
    tl.texlive-scripts # fmtutil, updmap
    tl.texlive-scripts-extra # texlinks
    perl
  ];

  buildInputs = [ coreutils gawk gnugrep gnused ] ++ lib.optional needsGhostscript ghostscript;

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

  passthru = {
    # build only the formats of a package (for internal use!)
    __formatsOf = args.__formatsOf or null;
    requiredTeXPackages = args.requiredTeXPackages or (ps: [ ps.scheme-infraonly ]);
    # this is for tests.texlive.licenses to compute the final license of the scheme
    includedTeXPackages = builtins.filter lib.isDerivation (pkgList.bin ++ pkgList.nonbin
      ++ lib.optionals (! __fromCombineWrapper)
        (lib.concatMap (n: (pkgList.otherOutputs.${n} or [ ] ++ pkgList.specifiedOutputs.${n} or [ ]))) pkgList.nonEnvOutputs);
    # useful for inclusion in the `fonts.packages` nixos option or for use in devshells
    fonts = "${finalAttrs.texmfroot}/texmf-dist/fonts";
    # support variants attrs, (prev: attrs)
    __overrideTeXConfig = newArgs:
      let appliedArgs = if builtins.isFunction newArgs
        then newArgs (finalAttrs // { inherit (finalAttrs.passthru) requiredTeXPackages; __fromCombineWrapper = false; })
        else newArgs // { __fromCombineWrapper = false; };
        adjustedArgs = appliedArgs // lib.optionalAttrs (appliedArgs ? requiredTeXPackages) {
          passthru = appliedArgs.passthru // {
            inherit (appliedArgs) requiredTeXPackages;
          };
        };
        in finalPackage.overrideAttrs adjustedArgs;
    withPackages = reqs: finalPackage.overrideAttrs (prev: {
      passthru = prev.passthru // {
        requiredTeXPackages = ps: prev.passthru.requiredTeXPackages ps ++ reqs ps;
      };
      __combine = false;
      __fromCombineWrapper = false;
    });
  };

  __formatsOf = __formatsOf.pname or null;

  texmfdist = buildEnv' {
    name = "${finalAttrs.name}-texmfdist";

    # remove fake derivations (without 'outPath') to avoid undesired build dependencies
    paths = builtins.catAttrs "outPath" pkgList.nonbin;

    # mktexlsr
    nativeBuildInputs = [ tl."texlive.infra" ];

    postBuild = # generate ls-R database
    ''
      mktexlsr "$out"
    '';
  };

  tlpkg = buildEnv' {
    name = "${finalAttrs.name}-tlpkg";

    # remove fake derivations (without 'outPath') to avoid undesired build dependencies
    paths = builtins.catAttrs "outPath" pkgList.tlpkg;
  };

  # the 'non-relocated' packages must live in $TEXMFROOT/texmf-dist
  # and sometimes look into $TEXMFROOT/tlpkg (notably fmtutil, updmap look for perl modules in both)
  texmfroot = runCommand "${finalAttrs.name}-texmfroot" {
      inherit (finalAttrs) texmfdist tlpkg;
    } ''
      mkdir -p "$out"
      ln -s "$texmfdist" "$out"/texmf-dist
      ln -s "$tlpkg" "$out"/tlpkg
    '';

  fontconfigFile = makeFontsConf { fontDirectories = [ "${finalAttrs.texmfroot}/texmf-dist/fonts" ]; };

  fmtutilCnf = assembleConfigLines fmtutilLines pkgList.sortedFormatPkgs;
  updmapCfg = assembleConfigLines updmapLines pkgList.sortedFontMaps;

  languageDat = assembleConfigLines langDatLines pkgList.sortedHyphenPatterns;
  languageDef = assembleConfigLines langDefLines pkgList.sortedHyphenPatterns;
  languageLua = assembleConfigLines langLuaLines pkgList.sortedHyphenPatterns;

  postactionScripts = builtins.catAttrs "postactionScript" pkgList.tlpkg;

  inherit buildEnvCommand;

  postHook = ''
    . "${./build-tex-env.sh}"
  '';
}))
