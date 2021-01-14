{ lib, stdenv
, fetchurl
, fetchzip
, autoPatchelfHook
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
    autoPatchelfHook
  ];

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
      mkdir -p $out/bin
        for f in configuration features p2 plugins Archi.ini Archi; do
          cp $f $out/bin/
        done

        install -D -m755 Archi $out/bin/Archi
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
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ earldouglas SuperSandro2000 ];
  };
}
