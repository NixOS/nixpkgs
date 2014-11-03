{ stdenv, fetchurl, cmake, automoc4, kdelibs, libbluedevil, shared_mime_info, gettext }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bluedevil";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0di3hwgqzhx51x172wnbccf9f84cg69mab83qkcif0v3gv3pzy4f";
  };

  buildInputs = [ cmake kdelibs libbluedevil shared_mime_info automoc4 gettext ];

  meta = with stdenv.lib; {
    description = "Bluetooth manager for KDE";
    license = stdenv.lib.licenses.gpl2;
    inherit (kdelibs.meta) platforms;
    maintainers = [ maintainers.phreedom ];
  };

}
