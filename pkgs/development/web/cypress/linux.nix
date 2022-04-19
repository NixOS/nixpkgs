{ alsa-lib
, autoPatchelfHook
, callPackage
, fetchzip
, gtk2
, gtk3
, lib
, mesa
, nss
, stdenv
, udev
, unzip
, wrapGAppsHook
, xorg
}:

args@{ meta
, pname
, src
, version
}:

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchzip args.src;

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook unzip ];

  buildInputs = with xorg; [
    libXScrnSaver
    libXdamage
    libXtst
    libxshmfence
  ] ++ [
    nss
    gtk2
    alsa-lib
    gtk3
    mesa # for libgbm
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/cypress
    cp -vr * $out/opt/cypress/
    # Let's create the file binary_state ourselves to make the npm package happy on initial verification.
    # Cypress now verifies version by reading bin/resources/app/package.json
    mkdir -p $out/bin/resources/app
    printf '{"version":"%b"}' $version > $out/bin/resources/app/package.json
    # Cypress now looks for binary_state.json in bin
    echo '{"verified": true}' > $out/binary_state.json
    ln -s $out/opt/cypress/Cypress $out/bin/Cypress

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.py;

    tests = {
      example = callPackage ./cypress-example-kitchensink { };
    };
  };

  meta = with lib; args.meta // {
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tweber mmahut ];
  };
}
