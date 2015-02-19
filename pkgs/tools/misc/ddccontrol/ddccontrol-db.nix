{ stdenv, fetchurl, perl, perlPackages, libxml2, pciutils, pkgconfig, gtk  }:
let version = "20061014"; in
let verName = "${version}"; in
stdenv.mkDerivation {
         name = "ddccontrol-db-${verName}";
	 src = fetchurl {
               url = "mirror://sourceforge/ddccontrol/ddccontrol-db/${verName}/ddccontrol-db-${verName}.tar.bz2";
               sha1 = "9d06570fdbb4d25e397202a518265cc1173a5de3";
           };
	 buildInputs =
             [ stdenv perl perlPackages.libxml_perl libxml2 pciutils pkgconfig gtk ];
	 meta=  with stdenv.lib; {
      	    description = "Monitor database for DDCcontrol";
            license = licenses.gpl2;
            platforms = platforms.linux;
         };
}