{ pkgs, fetchurl, stdenv, gtk3, pkgconfig, intltool, alsaLib }:

stdenv.mkDerivation rec {
  name = "volumeicon-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "http://softwarebakery.com/maato/files/volumeicon/volumeicon-0.5.0.tar.gz";
    sha256 = "10np3fvfzyxkjw0kfzg81a7kcxda1fz6nkqffkijbay5ksgigwg5";
  };

  buildInputs = [ gtk3 pkgconfig intltool alsaLib ];

  meta = with stdenv.lib; {
    description = "A lightweight volume control that sits in your systray.";
    homepage = "http://softwarebakery.com/maato/volumeicon.html";
    platforms = pkgs.lib.platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
    license = pkgs.lib.licenses.gpl3;
  };

}

