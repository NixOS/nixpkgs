{
  lib,
  nodejs-slim,
  symlinkJoin,
}:
symlinkJoin {
  pname = "nodejs";
  inherit (nodejs-slim) version passthru meta;
  paths = [
    nodejs-slim
    nodejs-slim.npm
  ]
  ++ lib.optional (builtins.hasAttr "corepack" nodejs-slim) nodejs-slim.corepack;
}
