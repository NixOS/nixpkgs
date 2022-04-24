{ lib, stdenvNoCC, fetchFromGitHub, python3, makeWrapper, unstableGitUpdater, nixosTests }:

let
  pythonEnv = python3.withPackages (packages: with packages; [
    tornado
    pyserial-asyncio
    pillow
    lmdb
    streaming-form-data
    distro
    inotify-simple
    libnacl
    paho-mqtt
    pycurl
    zeroconf
    preprocess-cancellation
    jinja2
    dbus-next
    apprise
  ]);
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "unstable-2022-03-10";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "ee312ee9c6597c8d077d7c3208ccea4e696c97ca";
    sha256 = "l0VOQIfKgZ/Je4z+SKhWMgYzxye8WKs9W1GkNs7kABo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/lib
    cp -r moonraker $out/lib

    makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
      --add-flags "$out/lib/moonraker/moonraker.py"
  '';

  passthru = {
    updateScript = unstableGitUpdater { url = meta.homepage; };
    tests.moonraker = nixosTests.moonraker;
  };

  meta = with lib; {
    description = "API web server for Klipper";
    homepage = "https://github.com/Arksine/moonraker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
