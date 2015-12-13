{stdenv, fetchurl, python, pythonPackages, par2cmdline, unzip, unrar}:

stdenv.mkDerivation rec {
  version = "0.7.20";
  name = "sabnzbd-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sabnzbdplus/SABnzbd-${version}-src.tar.gz";
    sha256 = "0hl7mwgyvm4d68346s7vlv0qlibfh2p2idpyzpjfvk8f79hs9cr0";
  };

  pythonPath = with pythonPackages; [ pyopenssl sqlite3 cheetah ];
  buildInputs = with pythonPackages; [wrapPython];
  inherit python par2cmdline unzip unrar;

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = http://sabnzbd.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
