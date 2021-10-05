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
  version = "unstable-2021-09-21";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "2447ccab6252fddc829da3eec8b29d1abe3dee60";
    sha256 = "qaorF26e2pkOCxiUfo8MOPQVpZjx5G1uo66jFoQpMcs=";
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
