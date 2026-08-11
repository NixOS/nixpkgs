{
  lib,
  nodejs-slim,
  symlinkJoin,
}:
let
  hasDisallowedPrefix = lib.hasPrefix "__";
  allowedNames = [
    "override"
    "overrideAttrs"
    "overrideDerivation"
    "outputs"
    "outputName"
    "system"
    "type"

    # Filter out arguments of `getOutput`
    "bin"
    "dev"
    "include"
    "lib"
    "man"
    "out"
    "static"

    # Filter out outputs that didn't exist on 25.11
    "npm"
    "corepack"
  ];
in
(symlinkJoin {
  pname = "nodejs";
  inherit (nodejs-slim) version passthru meta;
  paths = [
    nodejs-slim
    nodejs-slim.npm
  ]
  ++ lib.optional (builtins.hasAttr "corepack" nodejs-slim) nodejs-slim.corepack;
}).overrideAttrs
  (nodejs: {
    passthru =
      (builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = lib.warn "Use nodejs-slim.${name} instead of nodejs.${name}" nodejs-slim.${name};
          })
          (
            builtins.filter (
              name: !hasDisallowedPrefix name && !(builtins.elem name allowedNames) && !(nodejs ? ${name})
            ) (builtins.attrNames nodejs-slim)
          )
      ))
      // nodejs.passthru;
  })
