{ lib, stdenv, fetchurl, libpcap }:

stdenv.mkDerivation rec {
  pname = "cdpr";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}-${version}.tgz";
    sha256 = "1idyvyafkk0ifcbi7mc65b60qia6hpsdb6s66j4ggqp7if6vblrj";
  };

  buildInputs = [ libpcap ];

  installPhase = ''
    install -Dm755 cdpr $out/bin/cdpr
  '';

  meta = with lib; {
    description = "Cisco Discovery Protocol Reporter";
    homepage = "http://cdpr.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.sgo ];
  };
}
