{ lib, gemConfig, ... }:
rec {
  bundlerFiles = {
    gemfile ? null
  , lockfile ? null
  , gemset ? null
  , gemdir ? null
  , ...
  }: {
    inherit gemdir;

    gemfile =
    if gemfile == null then assert gemdir != null; gemdir + "/Gemfile"
    else gemfile;

    lockfile =
    if lockfile == null then assert gemdir != null; gemdir + "/Gemfile.lock"
    else lockfile;

    gemset =
    if gemset == null then assert gemdir != null; gemdir + "/gemset.nix"
    else gemset;
  };

  filterGemset = {ruby, groups,...}@env: gemset: lib.filterAttrs (name: attrs: platformMatches ruby attrs && groupMatches groups attrs) gemset;

  platformMatches = {rubyEngine, version, ...}@ruby: attrs: (
  !(attrs ? "platforms") ||
  builtins.length attrs.platforms == 0 ||
    builtins.any (platform:
      platform.engine == rubyEngine &&
        (!(platform ? "version") || platform.version == version.majMin)
    ) attrs.platforms
  );

  groupMatches = groups: attrs: (
  !(attrs ? "groups") ||
    builtins.any (gemGroup: builtins.any (group: group == gemGroup) groups) attrs.groups
  );

  applyGemConfigs = attrs:
    (if gemConfig ? "${attrs.gemName}"
    then attrs // gemConfig."${attrs.gemName}" attrs
    else attrs);

  genStubsScript = { lib, ruby, confFiles, bundler, groups, binPaths, ... }: ''
      ${ruby}/bin/ruby ${./gen-bin-stubs.rb} \
        "${ruby}/bin/ruby" \
        "${confFiles}/Gemfile" \
        "$out/${ruby.gemPath}" \
        "${bundler}/${ruby.gemPath}" \
        ${lib.escapeShellArg binPaths} \
        ${lib.escapeShellArg groups}
    '';

  pathDerivation = { gemName, version, path, ...  }:
    let
      res = {
          type = "derivation";
          bundledByPath = true;
          name = gemName;
          version = version;
          outPath = path;
          outputs = [ "out" ];
          out = res;
          outputName = "out";
        };
    in res;

  composeGemAttrs = ruby: gems: name: attrs: ((removeAttrs attrs ["source" "platforms"]) // attrs.source // {
    inherit ruby;
    gemName = name;
    gemPath = map (gemName: gems."${gemName}") (attrs.dependencies or []);
  });
}
