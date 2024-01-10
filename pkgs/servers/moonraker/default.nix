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
    ]
    ++ (lib.optionals useGpiod [ libgpiod ])
  );
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "unstable-2023-12-16";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "42357891a3716cd332ef60b28af09f8732dbf67a";
    sha256 = "sha256-5w336GaHUkbmhAPvhOO3kNW5q7qTFVw3p0Q+Rv+YdYM=";
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
    mainProgram = "moonraker";
  };
}
