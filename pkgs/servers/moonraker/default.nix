{ lib, stdenvNoCC, fetchFromGitHub, python3, makeWrapper, unstableGitUpdater, nixosTests, useGpiod ? false }:

let
  pythonEnv = python3.withPackages (packages:
    with packages; [
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
      python-periphery
      ldap3
    ]
  );
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "0.9.2-unstable-2024-07-30";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "b40751ba9d7f05e7da81636e3e4a5735ef85bb27";
    sha256 = "sha256-tkK47QxNy9ejHIagFeRb/ytM+Of92pkYvD4APi7sp0c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/lib
    cp -r moonraker $out/lib

    makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
      --add-flags "$out/lib/moonraker/moonraker.py"
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      url = meta.homepage;
      tagPrefix = "v";
    };
    tests.moonraker = nixosTests.moonraker;
  };

  meta = with lib; {
    description = "API web server for Klipper";
    homepage = "https://github.com/Arksine/moonraker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
    mainProgram = "moonraker";
  };
}
