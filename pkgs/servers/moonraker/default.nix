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
  version = "0.8.0-unstable-2024-06-23";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "8f3b30a04f0ffd5902075f15c52bc276e54ff690";
    sha256 = "sha256-sv0zjQ1znSZxdFCbXVl+pv1bh4sbXoVbDlZ6LfiKe/U=";
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
