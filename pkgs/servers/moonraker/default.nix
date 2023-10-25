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
  version = "unstable-2022-11-18";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "362bc1a3d3ad397416f7fc48b8efe33837428b90";
    sha256 = "sha256-cebRHOx2hg470jM1CoQAk13Whv+KN2qx97BTlpjxSZg=";
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
