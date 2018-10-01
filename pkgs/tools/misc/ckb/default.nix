{ stdenv, fetchFromGitHub, cmake, pkgconfig, systemd, udev, substituteAll
, qtbase, zlib, kmod, libpulseaudio, libappindicator-gtk2, gnused }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "ckb-next-${version}";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "1jivz6k4qkjykps5z80dhbs2pgn6w2nwam52w56yg8393zskknn8";
  };

  buildInputs = [
    systemd udev qtbase zlib gnused
    libpulseaudio libappindicator-gtk2
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  patches = [
    (substituteAll {
      name = "ckb-modprobe.patch";
      src = ./ckb-modprobe.patch;
      inherit kmod;
    })
    ./daemon.patch
    ./libs_ckb_next.patch
    ./dev_name.patch
    #Update udev rules for /dev/input/by-id. remove on next ckb release.
    (substituteAll {
      name = "udev_rules.patch";
      src = ./udev_rules.patch;
      inherit gnused;
    })
  ];

  doCheck = false;

  #installPhase = ''
  #  runHook preInstall

  #  install -D --mode 0755 --target-directory $out/bin bin/ckb-daemon bin/ckb
  #  install -D --mode 0755 --target-directory $out/libexec/ckb-animations bin/ckb-animations/*

  #  runHook postInstall
  #'';

  meta = with stdenv.lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = https://github.com/ckb-next/ckb-next;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
