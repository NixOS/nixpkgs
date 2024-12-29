{ lib
, symlinkJoin
, runCommand
, unwrapped
, python3
, formats
}:

let wrapper = { pythonPackages ? (_: [ ]), plugins ? (_: [ ]), baseConfig ? null }:
  let
    plugins' = plugins unwrapped.plugins;
    extraPythonPackages = builtins.concatLists (map (p: p.propagatedBuildInputs or [ ]) plugins');
  in
  symlinkJoin {
    name = "${unwrapped.pname}-with-plugins-${unwrapped.version}";

    inherit unwrapped;
    paths = lib.optional (baseConfig != null) unwrapped ++ plugins';
    pythonPath = lib.optional (baseConfig == null) unwrapped ++ pythonPackages python3.pkgs ++ extraPythonPackages;

    nativeBuildInputs = [ python3.pkgs.wrapPython ];

    postBuild = ''
      rm -f $out/nix-support/propagated-build-inputs
      rmdir $out/nix-support || true
      ${lib.optionalString (baseConfig != null) ''
        rm $out/${python3.sitePackages}/maubot/example-config.yaml
        substituteAll ${(formats.yaml { }).generate "example-config.yaml" (lib.recursiveUpdate baseConfig {
          plugin_directories = lib.optionalAttrs (plugins' != []) {
            load = [ "@out@/lib/maubot-plugins" ] ++ (baseConfig.plugin_directories.load or []);
          };
          # Normally it should be set to false by default to take it from package
          # root, but aiohttp doesn't follow symlinks when serving static files
          # unless follow_symlinks=True is passed. Instead of patching maubot, use
          # this non-invasive approach
          # XXX: would patching maubot be better? See:
          # https://github.com/maubot/maubot/blob/75879cfb9370aade6fa0e84e1dde47222625139a/maubot/server.py#L106
          server.override_resource_path =
            if builtins.isNull (baseConfig.server.override_resource_path or null)
            then "${unwrapped}/${python3.sitePackages}/maubot/management/frontend/build"
            else baseConfig.server.override_resource_path;
        })} $out/${python3.sitePackages}/maubot/example-config.yaml
        rm -rf $out/bin
      ''}
      mkdir -p $out/bin
      cp $unwrapped/bin/.mbc-wrapped $out/bin/mbc
      cp $unwrapped/bin/.maubot-wrapped $out/bin/maubot
      wrapPythonProgramsIn "$out/bin" "${lib.optionalString (baseConfig != null) "$out "}$pythonPath"
    '';

    passthru = {
      inherit unwrapped;
      python = python3;
      withPythonPackages = filter: wrapper {
        pythonPackages = pkgs: pythonPackages pkgs ++ filter pkgs;
        inherit plugins baseConfig;
      };
      withPlugins = filter: wrapper {
        plugins = pkgs: plugins pkgs ++ filter pkgs;
        inherit pythonPackages baseConfig;
      };
      withBaseConfig = baseConfig: wrapper {
        inherit baseConfig pythonPackages plugins;
      };
    };

    meta.priority = (unwrapped.meta.priority or 0) - 1;
  };
in
wrapper
