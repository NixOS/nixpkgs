{ stdenv, fetchFromGitHub, libudev, pkgconfig, qtbase, qmake, zlib }:

stdenv.mkDerivation rec {
  version = "0.2.8";
  name = "ckb-next-${version}";

  src = fetchFromGitHub {
    owner = "mattanger";
    repo = "ckb-next";
    rev = "v${version}";
    sha256 = "0b3h1d54mdyfcx46zvsd7dfqf2656h4jjkiw044170gnfdzxjb3w";
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
