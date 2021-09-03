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
  ]);
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "unstable-2021-07-18";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "42f61ceafa90fcfea8bffbe968e26a6fd8b61af6";
    sha256 = "1w6l9pgs4n4nnk3h40y346bf6j3v4j4h1qnhj5dwlbwdxiqpd9gs";
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
