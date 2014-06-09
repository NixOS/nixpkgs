{stdenv, fetchurl, python, pythonPackages, cheetahTemplate, makeWrapper, par2cmdline, unzip, unrar}:

stdenv.mkDerivation rec {
  name = "sabnzbd-0.7.17";
  
  src = fetchurl {
    url = mirror://sourceforge/sabnzbdplus/SABnzbd-0.7.17-src.tar.gz;
    sha256 = "02gbh3q3qnbwy4xn1hw4i4fyw4j5nkrqy4ak46mxwqgip9ym20d5";
  };

  buildInputs = [makeWrapper python sqlite3 cheetahTemplate];
  inherit stdenv python cheetahTemplate par2cmdline unzip unrar; 
  inherit (pythonPackages) sqlite3;

  builder = ./builder.sh;
  
  meta = {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
  };
}
