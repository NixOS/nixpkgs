{
  lib,
  stdenv,
}:

# This builder provides a thin facade that wraps the fod into a derivation
# so that plugins can be picked up for automated updates. The actual build
# happens when they are passed into the nginx build, which is why there is
# no need to build these in hydra.

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  extendDrvArgs = finalAttrs: args: {
    name = "nginx-mod-${args.pname}-${args.version}";
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      cp \
        --recursive \
        --no-preserve=ownership \
        . \
        "$out"
      runHook postInstall
    '';

    meta = (
      args.meta or { }
      // {
        hydraPlatforms = [ ];
      }
    );
  };
}
