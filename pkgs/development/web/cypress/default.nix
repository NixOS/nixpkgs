{ alsa-lib
, autoPatchelfHook
, fetchzip
, gtk2
, gtk3
, lib
, buildPackages
, makeShellWrapper
, libgbm
, nss
, stdenv
, udev
, unzip
, xorg
, darwin
}:

let
  availableBinaries = {
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-1W13AfXVRWTmDSRdsaPfSSJNlf59JXdI92tXBbYwdDI=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-rB0ak6jYnJMb0aHDLAyhaGoOFK4FXDLEOeofNdW/Wk8=";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-L2rhtB/DIK7Qum2YNoWVBn4mf+DA3rbcBUfZEEa/C8c=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-glJscAp0oHS1pqBt6fsQm0I5anl2HQ5YawIJuPG33II=";
    };
  };
  inherit (stdenv.hostPlatform) system;
  binary = availableBinaries.${system} or (throw "cypress: No binaries available for system ${system}");
  inherit (binary) platform hash;
in stdenv.mkDerivation rec {
  pname = "cypress";
  version = "13.17.0";

  src = fetchzip {
    url = "https://cdn.cypress.io/desktop/${version}/${platform}/cypress.zip";
    inherit hash;
    stripRoot = !stdenv.hostPlatform.isDarwin;
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs =
    [
      unzip
      makeShellWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
      (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    ];


  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (with xorg; [
    libXScrnSaver
    libXdamage
    libXtst
    libxshmfence
    nss
    gtk2
    alsa-lib
    gtk3
    libgbm
  ]) ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
    CoreServices
    CoreMedia
    CoreAudio
    AudioToolbox
    AVFoundation
    Foundation
    ApplicationServices
  ]);

  runtimeDependencies = lib.optional stdenv.hostPlatform.isLinux (lib.getLib udev);

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
    ${if stdenv.hostPlatform.isDarwin then ''
      ln -s $out/opt/cypress/Cypress.app/Contents/MacOS/Cypress $out/bin/cypress
    '' else ''
      ln -s $out/opt/cypress/Cypress $out/bin/cypress
    ''}
    runHook postInstall
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # exit with 1 after 25.05
    makeWrapper $out/opt/cypress/Cypress $out/bin/Cypress \
      --run 'echo "Warning: Use the lowercase cypress executable instead of the capitalized one."'
  '';

  passthru = {
    updateScript = ./update.sh;

    tests = {
      # We used to have a test here, but was removed because
      #  - it broke, and ofborg didn't fail https://github.com/NixOS/ofborg/issues/629
      #  - it had a large footprint in the repo; prefer RFC 92 or an ugly FOD fetcher?
      #  - the author switched away from cypress.
      # To provide a test once more, you may find useful information in
      # https://github.com/NixOS/nixpkgs/pull/223903
    };
  };

  meta = with lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser";
    homepage = "https://www.cypress.io";
    mainProgram = "Cypress";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = lib.attrNames availableBinaries;
    maintainers = with maintainers; [ tweber mmahut Crafter ];
  };
}
