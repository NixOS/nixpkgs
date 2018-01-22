{ stdenv, fetchFromGitHub, libudev, pkgconfig, qtbase, qmake, zlib }:

stdenv.mkDerivation rec {
  version = "2018-01-01";
  name = "ckb-next-${version}";

  src = fetchFromGitHub {
    owner = "mattanger";
    repo = "ckb-next";
    rev = "a0e35b5ba4d624210bf40f6c20891d8327ea17dc";
    sha256 = "14lkhwmpka9vy2xrrsh3lbhqz3dkjvvqshqpg1h1w8qsqaqk3r6m";
  };

  buildInputs = [
    libudev
    qtbase
    zlib
  ];

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  patches = [
    ./ckb-animations-location.patch
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
    homepage = https://github.com/mattanger/ckb-next;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kierdavis ];
  };
}
