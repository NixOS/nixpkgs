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

    # ckb daemon loads a kernel module by calling the actual modprobe binary
    (substituteAll {
      name = "ckb-modprobe.patch";
      src = ./ckb-modprobe.patch;
      inherit kmod;
    })

    # stop cmake trying to install to /usr and /etc
    ./daemon.patch

    # stop cmake trying to install to /etc
    ./libs_ckb_next.patch

    ./dev_name.patch # add correct device alias (mouse vs keyboard)

    # ckb's udev rule runs sed on device name for some reason
    (substituteAll {
      name = "udev_rules.patch";
      src = ./udev_rules.patch;
      inherit gnused;
    })

  ];

  meta = with stdenv.lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = https://github.com/ckb-next/ckb-next;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
