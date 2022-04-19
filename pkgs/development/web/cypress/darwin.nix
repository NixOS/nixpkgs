{ callPackage
, fetchzip
, lib
, stdenvNoCC
}:

args@{ meta
, pname
, src
, version
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchzip (args.src // {
    stripRoot = false;
  });

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Cypress.app "$out/Applications"

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.py;

    tests = {
      example = callPackage ./cypress-example-kitchensink { };
    };
  };

  meta = with lib; args.meta // {
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ steinybot ];
  };
}
