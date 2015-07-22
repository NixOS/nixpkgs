{ stdenv, fetchurl, cmake, automoc4, kdelibs, libbluedevil, shared_mime_info, gettext }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bluedevil";
  # bluedevil must have the same major version (x.y) as libbluedevil!
  # do not update this package without checking libbluedevil
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1rcx1dfm6sm90pvwyq224a1pph96chrmyiv1rry7zpb3hf2c73gi";
  };

  buildInputs = [ cmake kdelibs libbluedevil shared_mime_info automoc4 gettext ];

  meta = with stdenv.lib; {
    description = "Bluetooth manager for KDE";
    license = stdenv.lib.licenses.gpl2;
    inherit (kdelibs.meta) platforms;
    maintainers = [ maintainers.phreedom ];
  };

}
