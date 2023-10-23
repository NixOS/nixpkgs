{ lib
, rnix-hashes
, runCommand
, fetchurl
  # The path to the right MODULE.bazel.lock
, lockfile
  # The path to a json file containing the list of hashes we should prefetch
, requiredDeps ? null
, extraInputs ? [ ]
}:
let
  modules = builtins.fromJSON (builtins.readFile lockfile);

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

  extract_source = f: acc: value:
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
    let
      attrs = value.attributes;
      entry = hash: urls: {
        ${hash} = fetchurl {
          name = "source"; # just like fetch*, to get some deduplication
          inherit urls;
          sha256 = hash;
          passthru.sha256 = hash;
        };
      };
      insert = acc: hash: urls:
        acc // entry (sanitize hash) (map sanitize urls);
      accWithRemotePatches = lib.foldlAttrs
        (acc: url: hash: insert acc hash [ url ])
        acc
        (attrs.remote_patches or { });
      accWithNewSource = insert
        accWithRemotePatches
        (attrs.integrity or attrs.sha256)
        (attrs.urls or [ attrs.url ]);
    in
    if builtins.isAttrs value && value ? attributes
      && (attrs ? sha256 || attrs ? integrity)
      && f attrs.name
    then accWithNewSource else acc;

  # remove the "--" prefix, abusing undocumented negative substring length
  sanitize = builtins.substring 2 (-1);

  inputs = foldlJSON (extract_source (n: builtins.trace (sanitize n) true)) { } modules;

  requiredHashes = builtins.fromJSON (builtins.readFile requiredDeps);
  requiredAttrs = lib.genAttrs requiredHashes throw;

  requiredInputs =
    if requiredDeps == null
    then inputs
    else builtins.intersectAttrs requiredAttrs (builtins.trace inputs inputs);

  command = ''
    mkdir -p $out/content_addressable/sha256
    cd $out
  '' + lib.concatMapStrings
    # TODO: Do not re-hash. Use nix-hash to convert hashes
    (drv: ''
      filename=$(basename "${lib.head drv.urls}")
      hash=$(${rnix-hashes}/bin/rnix-hashes --encoding BASE16 ${drv.sha256} | cut -f 2)
      mkdir -p content_addressable/sha256/$hash
      ln -sfn ${drv} content_addressable/sha256/$hash/file
      # Expect file name conflicts
      ln -sn ${drv} $filename || true
    '')
    (builtins.attrValues requiredInputs ++ extraInputs)
  ;

  repository_cache = runCommand "bazel-repository-cache" { } command;

in
repository_cache
