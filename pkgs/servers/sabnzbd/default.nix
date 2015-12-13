{stdenv, fetchurl, python, pythonPackages, cheetahTemplate, makeWrapper, par2cmdline, unzip, unrar}:

stdenv.mkDerivation rec {
  version = "0.7.20";
  name = "sabnzbd-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/sabnzbdplus/SABnzbd-${version}-src.tar.gz";
    sha256 = "0hl7mwgyvm4d68346s7vlv0qlibfh2p2idpyzpjfvk8f79hs9cr0";
  };

  buildInputs = [makeWrapper python sqlite3 cheetahTemplate];
  inherit stdenv python cheetahTemplate par2cmdline unzip unrar; 
  inherit (pythonPackages) sqlite3;

  builder = ./builder.sh;
  
  meta = {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
  };
}
