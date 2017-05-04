{ lib, ruby, groups, gemConfig, ... }:
rec {
  filterGemset = gemset: lib.filterAttrs (name: attrs: platformMatches attrs && groupMatches attrs) gemset;

  platformMatches = attrs: (
  !(attrs ? "platforms") ||
    builtins.any (platform:
      platform.engine == ruby.rubyEngine &&
        (!(platform ? "version") || platform.version == ruby.version.majMin)
    ) attrs.platforms
  );

  groupMatches = attrs: (
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

  composeGemAttrs = gems: name: attrs: ((removeAttrs attrs ["source"]) // attrs.source // {
    inherit ruby;
    gemName = name;
    gemPath = map (gemName: gems."${gemName}") (attrs.dependencies or []);
  });
}
