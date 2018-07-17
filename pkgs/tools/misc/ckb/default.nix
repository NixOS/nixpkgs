{ stdenv, fetchFromGitHub, substituteAll, udev
, pkgconfig, qtbase, qmake, zlib, kmod }:

stdenv.mkDerivation rec {
  version = "0.2.9";
  name = "ckb-next-${version}";

  src = fetchFromGitHub {
    owner = "ckb-next";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "0hl41znyhp3k5l9rcgz0gig36gsg95ivrs1dyngv45q9jkr6fchm";
  };

  buildInputs = [
    udev
    qtbase
    zlib
  ];

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  patches = [
    ./ckb-animations-location.patch
    (substituteAll {
      name = "ckb-modprobe.patch";
      src = ./ckb-modprobe.patch;
      inherit kmod;
    })
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -D --mode 0755 --target-directory $out/bin bin/ckb-daemon bin/ckb
    install -D --mode 0755 --target-directory $out/libexec/ckb-animations bin/ckb-animations/*

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Driver and configuration tool for Corsair keyboards and mice";
    homepage = https://github.com/ckb-next/ckb-next;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
