{ lib
, rnix-hashes
, runCommand
, fetchurl
  # The path to the right MODULE.bazel.lock
, lockfile
  # A predicate used to select only some dependencies based on their name
, requiredDepNamePredicate ? _: true
, canonicalIds ? true
}:
let
  modules = builtins.fromJSON (builtins.readFile lockfile);
  modulesVersion = modules.lockFileVersion;

  # A foldl' for moduleDepGraph repoSpecs.
  # We take any RepoSpec object under .moduleDepGraph.<moduleName>.repoSpec
  foldlModuleDepGraph = op: acc: value:
    if builtins.isAttrs value && value ? moduleDepGraph && builtins.isAttrs value.moduleDepGraph
    then
      lib.foldlAttrs
        (_acc: moduleDepGraphName: module: (
          if builtins.isAttrs module && module ? repoSpec
          then op _acc { inherit moduleDepGraphName; } module.repoSpec
          else _acc
        ))
        acc
        value.moduleDepGraph
    else acc;

  # a foldl' for moduleExtensions generatedRepoSpecs
  # We take any RepoSpec object under .moduleExtensions.<moduleExtensionName>.general.generatedRepoSpecs.<generatedRepoName>
  foldlGeneratedRepoSpecs = op: acc: value:
    if builtins.isAttrs value && value ? moduleExtensions
    then
      lib.foldlAttrs
        (_acc: moduleExtensionName: moduleExtension: (
          if builtins.isAttrs moduleExtension
            && moduleExtension ? general
            && builtins.isAttrs moduleExtension.general
            && moduleExtension.general ? generatedRepoSpecs
            && builtins.isAttrs moduleExtension.general.generatedRepoSpecs
          then
            lib.foldlAttrs
              (__acc: moduleExtensionGeneratedRepoName: repoSpec: (
                op __acc { inherit moduleExtensionName moduleExtensionGeneratedRepoName; } repoSpec
              ))
              _acc
              moduleExtension.general.generatedRepoSpecs
          else _acc
        ))
        acc
        value.moduleExtensions
    else acc;

  # remove the "--" prefix, abusing undocumented negative substring length
  sanitize = str:
    if modulesVersion < 3
    then builtins.substring 2 (-1) str
    else str;

  unmangleName = mangledName:
    if mangledName ? moduleDepGraphName
    then builtins.replaceStrings [ "@" ] [ "~" ] mangledName.moduleDepGraphName
    else
    # given moduleExtensionName = "@scope~//path/to:extension.bzl%extension"
    # and moduleExtensionGeneratedRepoName = "repoName"
    # return "scope~extension~repoName"
      let
        isMainModule = lib.strings.hasPrefix "//" mangledName.moduleExtensionName;
        moduleExtensionParts = builtins.split "^@*([a-zA-Z0-9_~]*)//.*%(.*)$" mangledName.moduleExtensionName;
        match = if (builtins.length moduleExtensionParts >= 2) then builtins.elemAt moduleExtensionParts 1 else [ "unknownPrefix" "unknownScope" "unknownExtension" ];
        scope = if isMainModule then "_main" else builtins.elemAt match 0;
        extension = builtins.elemAt match 1;
      in
      "${scope}~${extension}~${mangledName.moduleExtensionGeneratedRepoName}";

  # We take any "attributes" object that has a "sha256" field. Every value
  # under "attributes" is assumed to be an object, and all the "attributes"
  # with a "sha256" field are assumed to have either a "urls" or "url" field.
  #
  # We add them to the `acc`umulator:
  #
  #    acc // {
  #      "ffad2b06ef2e09d040...fc8e33706bb01634" = fetchurl {
  #        name = "source";
  #        sha256 = "ffad2b06ef2e09d040...fc8e33706bb01634";
  #        urls = [
  #          "https://mirror.bazel.build/github.com/golang/library.zip",
  #          "https://github.com/golang/library.zip"
  #        ];
  #      };
  #    }
  #
  # !REMINDER! This works on a best-effort basis, so try to keep it from
  # failing loudly. Prefer warning traces.
  extract_source = f: acc: mangledName: value:
    let
      attrs = value.attributes;
      name = unmangleName mangledName;
      entry = hash: urls: name: {
        ${hash} = fetchurl {
          name = "source"; # just like fetch*, to get some deduplication
          inherit urls;
          sha256 = hash;
          passthru.sha256 = hash;
          passthru.source_name = name;
          passthru.urls = urls;
        };
      };
      insert = acc: hash: urls:
        let
          validUrls = builtins.isList urls
            && builtins.all (url: builtins.isString url && builtins.substring 0 4 url == "http") urls;
          validHash = builtins.isString hash;
          valid = validUrls && validHash;
        in
        if valid then acc // entry hash urls name
        else acc;
      withToplevelValue = acc: insert acc
        (attrs.integrity or attrs.sha256)
        (attrs.urls or [ attrs.url ]);
      # for http_file patches
      withRemotePatches = acc: lib.foldlAttrs
        (acc: url: hash: insert acc hash [ url ])
        acc
        (attrs.remote_patches or { });
      # for _distdir_tar
      withArchives = acc: lib.foldl'
        (acc: archive: insert acc attrs.sha256.${archive} attrs.urls.${archive})
        acc
        (attrs.archives or [ ]);
      addSources = acc: withToplevelValue (withRemotePatches (withArchives acc));
    in
    if builtins.isAttrs value && value ? attributes
      && value ? ruleClassName
      && builtins.isAttrs attrs
      && (attrs ? sha256 || attrs ? integrity)
      && (attrs ? urls || attrs ? url)
      && f name
    then addSources acc
    else acc;

  requiredSourcePredicate = n: requiredDepNamePredicate (sanitize n);
  requiredDeps = foldlModuleDepGraph (extract_source requiredSourcePredicate) { } modules // foldlGeneratedRepoSpecs (extract_source requiredSourcePredicate) { } modules;

  command = ''
    mkdir -p $out/content_addressable/sha256
    cd $out
  '' + lib.concatMapStrings
    (drv: ''
      filename=$(basename "${lib.head drv.urls}")
      echo Bundling $filename ${lib.optionalString (drv?source_name) "from ${drv.source_name}"}

      # 1. --repository_cache format:
      # 1.a. A file under a content-hash directory
      hash=$(${rnix-hashes}/bin/rnix-hashes --encoding BASE16 ${drv.sha256} | cut -f 2)
      mkdir -p content_addressable/sha256/$hash
      ln -sfn ${drv} content_addressable/sha256/$hash/file

      # 1.b. a canonicalId marker based on the download urls
      # Bazel uses these to avoid reusing a stale hash when the urls have changed.
      canonicalId="${lib.concatStringsSep " " drv.urls}"
      canonicalIdHash=$(echo -n "$canonicalId" | sha256sum | cut -d" " -f1)
      echo -n "$canonicalId" > content_addressable/sha256/$hash/id-$canonicalIdHash

      # 2. --distdir format:
      # Just a file with the right basename
      # Mostly to keep old tests happy, and because symlinks cost nothing.
      # This is brittle because of expected file name conflicts
      ln -sn ${drv} $filename || true
    '')
    (builtins.attrValues requiredDeps)
  ;

  repository_cache = runCommand "bazel-repository-cache" { } command;

in
repository_cache
