{ pkgs, lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "bootloadhid";
  version = "2012-12-08";

  src = fetchFromGitHub {
    owner = "pseud0n";
    repo = "bootloadHID";
    rev = "32af8b1abe23f3995e94e8eed0c771e59b959d30";
    sha256 = "17nml7siwk4v134r3cc5sqlg1m4780qy6sr8vz6bh5qgwp6hmj77";
  };
  
  buildInputs = with pkgs; [ pkgsCross.avr.buildPackages.gcc libusb-compat-0_1 ];

  buildPhase = ''
    cd commandline
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    chmod +x bootloadHID
    cp bootloadHID $out/bin
  '';

  meta = {
    description = "A software-only implementation of a low-speed USB device for Atmel’s AVR® microcontrollers";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.pseud0n ];
  };
}
