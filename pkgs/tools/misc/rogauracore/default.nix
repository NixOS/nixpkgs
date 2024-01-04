{ lib, stdenv, fetchgit, libusb1, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "rogauracore";
  version = "1.6.0";

  src = fetchFromGitHub {
    url = "https://github.com/wroberts/rogauracore";
    rev = "a872431a59e47c1ab0b2a523e413723bdcd93a6e";
    sha256 = "sha256-SeG6B9ksWH4/UjLq5yPncVMTYjqMOxOh2R3N0q29fQ0=";
  };

  buildInputs = [
    libusb1
    autoreconfHook
    #pkgs.boost
    #pkgs.cmake
  ];

  configurePhase = ''
    autoreconf -i
    ./configure
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv rogauracore $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Linux-compatible open-source libusb implementation similar to the ROG Aura Core software";
    homepage = "https://github.com/wroberts/rogauracore";
    maintainers = [ "truebad0ur" ];
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
}
