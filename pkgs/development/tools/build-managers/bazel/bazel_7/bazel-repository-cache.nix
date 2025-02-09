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

  # a foldl' for json values
  foldlJSON = op: acc: value:
    let
      # preorder, visit the current node first
      acc' = op acc value;

      # then visit child values, ignoring attribute names
      children =
        if builtins.isList value then
          lib.foldl' (foldlJSON op) acc' value
        else if builtins.isAttrs value then
          lib.foldlAttrs (_acc: _name: foldlJSON op _acc) acc' value
        else
          acc';
    in
    # like foldl', force evaluation of intermediate results
    builtins.seq acc' children;

  # remove the "--" prefix, abusing undocumented negative substring length
  sanitize = str:
    if modulesVersion < 3
    then builtins.substring 2 (-1) str
    else str;

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
  extract_source = f: acc: value:
    let
      attrs = value.attributes;
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
          validName = builtins.isString attrs.name;
          validHash = builtins.isString hash;
          valid = validUrls && validName && validHash;
        in
        if valid then acc // entry hash urls attrs.name
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
      && builtins.isAttrs attrs && attrs ? name
      && (attrs ? sha256 || attrs ? integrity)
      && (attrs ? urls || attrs ? url)
      && f attrs.name
    then addSources acc
    else acc;

  requiredSourcePredicate = n: requiredDepNamePredicate (sanitize n);
  requiredDeps = foldlJSON (extract_source requiredSourcePredicate) { } modules;

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
