{ lib, gemConfig, ... }:

let
  inherit (lib) attrValues concatMap converge filterAttrs getAttrs
                intersectLists;

in rec {
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

  filterGemset = { ruby, groups, ... }: gemset:
    let
      platformGems = filterAttrs (_: platformMatches ruby) gemset;
      directlyMatchingGems = filterAttrs (_: groupMatches groups) platformGems;

      expandDependencies = gems:
        let
          depNames = concatMap (gem: gem.dependencies or []) (attrValues gems);
          deps = getAttrs depNames platformGems;
        in
          gems // deps;
    in
      converge expandDependencies directlyMatchingGems;

  platformMatches = {rubyEngine, version, ...}: attrs: (
  !(attrs ? platforms) ||
  builtins.length attrs.platforms == 0 ||
    builtins.any (platform:
      platform.engine == rubyEngine &&
        (!(platform ? version) || platform.version == version.majMin)
    ) attrs.platforms
  );

  groupMatches = groups: attrs:
    groups == null || !(attrs ? groups) ||
      (intersectLists (groups ++ [ "default" ]) attrs.groups) != [];

  applyGemConfigs = attrs:
    (if gemConfig ? ${attrs.gemName}
    then attrs // gemConfig.${attrs.gemName} attrs
    else attrs);

  genStubsScript = { lib, runCommand, ruby, confFiles, bundler, groups, binPaths, ... }:
    let
      genStubsScript = runCommand "gen-bin-stubs"
        {
          strictDeps = true;
          nativeBuildInputs = [ ruby ];
        }
        ''
          cp ${./gen-bin-stubs.rb} $out
          chmod +x $out
          patchShebangs --build $out
        '';
    in
    ''
      ${genStubsScript} \
        "${ruby}/bin/ruby" \
        "${confFiles}/Gemfile" \
        "$out/${ruby.gemPath}" \
        "${bundler}/${ruby.gemPath}/gems/bundler-${bundler.version}" \
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
          outPath = "${path}";
          outputs = [ "out" ];
          out = res;
          outputName = "out";
          suffix = version;
          gemType = "path";
        };
    in res;

  composeGemAttrs = ruby: gems: name: attrs: ((removeAttrs attrs ["platforms"]) // {
    inherit ruby;
    inherit (attrs.source) type;
    source = removeAttrs attrs.source ["type"];
    gemName = name;
    gemPath = map (gemName: gems.${gemName}) (attrs.dependencies or []);
  });
}
