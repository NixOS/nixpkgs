{ stdenv, fetchFromGitHub, pkgconfig, jansson }:

let
  libsailing = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "libsailing";
    rev = "9b2863ff0c539cd23d91b0254032a7af9c840574";
    sha256 = "06rcxkwgms9sxqr1swnnc4jnvgs0iahm4cksd475yd1bp5p1gq6j";
  };
in
stdenv.mkDerivation rec {
  version = "0.3.0";
  pname = "sailsd";
  src = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "sailsd";
    rev = version;
    sha256 = "1s4nlffp683binbdxwwzbsci61kbjylbcr1jf44sv1h1r5d5js05";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ jansson libsailing ];

  INSTALL_PATH = "$(out)";

  postUnpack = ''
    rmdir $sourceRoot/libsailing
    cp -r ${libsailing} $sourceRoot/libsailing
    chmod 755 -R $sourceRoot/libsailing
  '';

  patchPhase = ''
    substituteInPlace Makefile \
      --replace gcc cc
  '';

  meta = with stdenv.lib; {
    description = "Simulator daemon for autonomous sailing boats";
    homepage = https://github.com/sails-simulator/sailsd;
    license = licenses.gpl3;
    longDescription = ''
      Sails is a simulator designed to test the AI of autonomous sailing
      robots. It emulates the basic physics of sailing a small single sail
      boat'';
    maintainers = with maintainers; [ kragniz ];
    platforms = platforms.all;
  };
}
