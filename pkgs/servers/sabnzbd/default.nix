{stdenv, fetchurl, python, cheetahTemplate, makeWrapper, par2cmdline, unzip, unrar}:

stdenv.mkDerivation {
  name = "sabnzbd-0.4.12";
  
  src = fetchurl {
    url = mirro://sourceforge/sabnzbdplus/SABnzbd-0.4.12-src.tar.gz;
    sha256 = "35ce4172688925ef608fba433ff676357dab7d2abdc1cf83112a1c99682fdd32";
  };

  buildInputs = [makeWrapper python cheetahTemplate];
  inherit stdenv python cheetahTemplate par2cmdline unzip unrar; 

  builder = ./builder.sh;
  
  meta = {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
  };
}
