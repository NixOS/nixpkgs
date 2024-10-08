{ lib, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, jdk
, libsecret
, webkitgtk
, wrapGAppsHook3
, _7zz
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "Archi";
  version = "5.3.0";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Linux64-${version}.tgz";
      hash = "sha256-ngO3YFCChsnefxdxtR00Dy736K2GYnTEYI4vKWLnPsw=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Mac-${version}.dmg";
      hash = "sha256-dL1c7IrbDMY/WbijQh1dCmCrRQQhj4fjGN+6m19OjO0=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Mac-Silicon-${version}.dmg";
      hash = "sha256-iczIUm1LCAjYKOyHXbFCgb+zoUxxATSOVkB8Ldk7pxQ=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    _7zz
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = if stdenv.hostPlatform.isDarwin then "." else null;

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        mkdir -p $out/bin $out/libexec
        for f in configuration features p2 plugins Archi.ini; do
          cp -r $f $out/libexec
        done

        install -D -m755 Archi $out/libexec/Archi
        makeWrapper $out/libexec/Archi $out/bin/Archi \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ webkitgtk ])} \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --prefix PATH : ${jdk}/bin
      ''
    else
      ''
        mkdir -p "$out/Applications"
        mv Archi.app "$out/Applications/"
      '';

  passthru.updateScript = ./update.sh;

  passthru.tests = { inherit (nixosTests) archi; };

  meta = with lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ earldouglas paumr ];
    mainProgram = "Archi";
  };
}
