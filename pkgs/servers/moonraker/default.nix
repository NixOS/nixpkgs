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
  version = "unstable-2021-10-03";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "c3f1b290f8667f771f2d58a3f012e87853c4e85c";
    sha256 = "a49sVvgzpGHrjWbSH6GiH5kGeXm1LrLgd+lKv7Xxi9w=";
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
