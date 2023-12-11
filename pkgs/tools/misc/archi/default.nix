{ lib, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, jdk
, libsecret
, webkitgtk
, wrapGAppsHook
, _7zz
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "Archi";
  version = "5.2.0";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi_5.php?/${version}/Archi-Linux64-${version}.tgz";
      hash = "sha256-uGW4Wl3E71ZCgWzPHkmXv/PluegDF8C64FUQ7C5/SDA=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi_5.php?/${version}/Archi-Mac-${version}.dmg";
      hash = "sha256-GI9aIAYwu60RdjN0Y3O94sVMzJR1+nX4txVcvqn1r58=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://www.archimatetool.com/downloads/archi_5.php?/${version}/Archi-Mac-Silicon-${version}.dmg";
      hash = "sha256-Jg+tl902OWSm4GHxF7QXbRU5nxX4/5q6LTGubHWQ08E=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system");

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    _7zz
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  unpackPhase = if stdenv.hostPlatform.isDarwin then ''
    7zz x $src
  '' else null;

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
