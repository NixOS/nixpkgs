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
  version = "unstable-2022-04-23";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "cd520ba91728abb5a3d959269fbd8e4f40d1eb0b";
    sha256 = "sha256-sopX9t+LjYldx+syKwU3I0x/VYy4hLyXfitG0uumayE=";
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
