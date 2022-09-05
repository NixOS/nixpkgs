{ lib, stdenv
, fetchurl
, fetchzip
, autoPatchelfHook
, makeWrapper
, jdk
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "Archi";
  version = "4.7.1";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://www.archimatetool.com/downloads/archi/Archi-Linux64-${version}.tgz";
        sha256 = "0sd57cfnh5q2p17sd86c8wgmqyipg29rz6iaa5brq8mwn8ps2fdw";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchzip {
        url = "https://www.archimatetool.com/downloads/archi/Archi-Mac-${version}.zip";
        sha256 = "1h05lal5jnjwm30dbqvd6gisgrmf1an8xf34f01gs9pwqvqfvmxc";
      }
    else
      throw "Unsupported system";

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        mkdir -p $out/bin $out/libexec
        for f in configuration features p2 plugins Archi.ini; do
          cp -r $f $out/libexec
        done

        install -D -m755 Archi $out/libexec/Archi
        makeWrapper $out/libexec/Archi $out/bin/Archi \
          --prefix PATH : ${jdk}/bin
      ''
    else
      ''
        mkdir -p "$out/Applications"
        mv Archi.app "$out/Applications/"
      '';

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
    maintainers = with maintainers; [ earldouglas ];
  };
}
