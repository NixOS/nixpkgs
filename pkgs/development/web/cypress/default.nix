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

stdenv.mkDerivation rec {
  pname = "cypress";
  version = "10.3.1";

  src = fetchzip {
    url = "https://cdn.cypress.io/desktop/${version}/linux-x64/cypress.zip";
    sha256 = "sha256-LfvTnvOGFFZn7tUQ150fCO0gw7TK6JJj+Ys75VjJJ2M=";
  };

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
    updateScript = ./update.sh;

    tests = {
      example = callPackage ./cypress-example-kitchensink { };
    };
  };

  meta = with lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser";
    homepage = "https://www.cypress.io";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tweber mmahut Crafter ];
  };
}
