{
  lib,
  nodejs-slim,
  symlinkJoin,
}:
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
              name:
              !lib.strings.hasPrefix "__" name
              && !(builtins.elem name [
                "override"
                "overrideAttrs"
                "overrideDerivation"
                "outputs"
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
              ])
              && !(builtins.hasAttr name nodejs)
            ) (builtins.attrNames nodejs-slim)
          )
      ))
      // nodejs.passthru;
  })
