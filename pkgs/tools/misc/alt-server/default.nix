{ stdenv
, fetchurl
, lib
, autoPatchelfHook
, avahi-compat
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "AltServer-Linux";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/NyaMisty/AltServer-Linux/releases/download/v${finalAttrs.version}/AltServer-x86_64";
    hash = "sha256-C+fDrcaewRd6FQMrO443xdDk/vtHycQ5zWLCOLPqF/s=";
  };

  buildInputs = [
    avahi-compat
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/alt-server
    chmod u+rx $out/bin/alt-server

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/NyaMisty/AltServer-Linux";
    description = "AltServer for AltStore, but on-device. Requires root privileges as well as running a custom anisette server currently.";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ max-amb ];
  };
})

