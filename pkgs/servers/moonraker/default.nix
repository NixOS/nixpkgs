{ lib, stdenvNoCC, fetchFromGitHub, python3, makeWrapper, unstableGitUpdater }:

let
  pythonEnv = python3.withPackages (packages: with packages; [
    tornado
    pyserial
    pillow
    lmdb
    streaming-form-data
    distro
    inotify-simple
    libnacl
    paho-mqtt
    pycurl
  ]);
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "unstable-2021-12-05";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "ac73036857cc1ca83df072dd94bf28eb9d0ed8b0";
    sha256 = "Oqjt0z4grt+hdQ4t7KQSwkkCeRGoFFedJsTpMHwMm34=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/lib
    cp -r moonraker $out/lib

    makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
      --add-flags "$out/lib/moonraker/moonraker.py"
  '';

  passthru.updateScript = unstableGitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "API web server for Klipper";
    homepage = "https://github.com/Arksine/moonraker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
