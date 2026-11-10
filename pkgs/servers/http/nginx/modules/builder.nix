{
  lib,
  stdenv,
  nix-update-script,
  nginx,
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

    passthru = args.passthru or { } // {
      updateScript =
        args.passthru.updateScript or (nix-update-script {
          extraArgs = [ "--version=stable" ];
        });
      tests = {
        nginx = nginx.override {
          modules = [ finalAttrs.finalPackage ];
        };
      }
      // args.passthru.tests or { };
    };

    meta = (
      args.meta or { }
      // {
        hydraPlatforms = [ ];
      }
    );
  };
}
