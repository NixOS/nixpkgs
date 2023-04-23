{ lib, stdenv, fetchurl, ppp }:

stdenv.mkDerivation rec {
  pname   = "pptpd";
  version = "1.4.0";

  src = fetchurl {
    url    = "mirror://sourceforge/poptop/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "1h06gyxj51ba6kbbnf6hyivwjia0i6gsmjz8kyggaany8a58pkcg";
  };

  buildInputs = [ ppp ];

  postPatch = ''
    substituteInPlace plugins/Makefile --replace "install -o root" "install"
  '';

  meta = with lib; {
    homepage    = "https://poptop.sourceforge.net/dox/";
    description = "The PPTP Server for Linux";
    platforms   = platforms.linux;
    maintainers = with maintainers; [ obadz ];
    license = licenses.gpl2;
  };
}
