{ symlinkJoin, lib, makeWrapper, writeText }:

helm:

let
  wrapper = {
    plugins ? [],
    extraMakeWrapperArgs ? ""
  }:
  let

  initialMakeWrapperArgs = [
  ];

  pluginsDir = symlinkJoin {
    name = "helm-plugins";
    paths = plugins;
  };
in
  symlinkJoin {
    name = "helm-${lib.getVersion helm}";

    # Remove the symlinks created by symlinkJoin which we need to perform
    # extra actions upon
    postBuild = ''
      wrapProgram "$out/bin/helm" \
        "--set" "HELM_PLUGINS" "${pluginsDir}" ${extraMakeWrapperArgs}
    '';
    paths = [ helm pluginsDir ];

    preferLocalBuild = true;

    nativeBuildInputs = [ makeWrapper ];
    passthru = { unwrapped = helm; };

    meta = helm.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [];
      # prefer wrapper over the package
      priority = (helm.meta.priority or 0) - 1;
    };
  };
in
  lib.makeOverridable wrapper
