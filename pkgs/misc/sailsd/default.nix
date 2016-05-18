{ stdenv, fetchFromGitHub, pkgconfig, jansson }:

let
  libsailing = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "libsailing";
    rev = "c24cddb717f81cd432868b8d41e04486c0a440fd";
    sha256 = "0mna0c9n8lvfdf4y1iigjy3dlks70hq6jik52zkik2yxvkqv949f";
  };
in
stdenv.mkDerivation rec {
  version = "0.2.0";
  name = "sailsd-${version}";
  src = fetchFromGitHub {
    owner = "sails-simulator";
    repo = "sailsd";
    rev = "${version}";
    sha256 = "147cr4aw1kw4gv3bhn0cska855kmyah8m70vdw1q2lwz56lbf4mb";
  };

  buildInputs = [ pkgconfig jansson libsailing ];

  INSTALL_PATH = "$(out)";

  postUnpack = ''
    rmdir $sourceRoot/libsailing
    cp -r ${libsailing} $sourceRoot/libsailing
    chmod 755 -R $sourceRoot/libsailing
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
