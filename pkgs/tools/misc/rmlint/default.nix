{ stdenv, fetchurl
, gettext, glib, json_glib, libelf, pkgconfig, scons, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rmlint-${version}";
  version = "2.4.4";

  src = fetchurl {
    url = "https://github.com/sahib/rmlint/archive/v${version}.tar.gz";
    sha256 = "1g38wmf58m9lbdngfsbz3dbkd44yqxppzvgi5mwag0w7r7khhir9";
  };

  configurePhase = "scons config";

  buildInputs = [ gettext glib json_glib libelf pkgconfig scons sphinx utillinux ];

  buildPhase = "scons";

  installPhase = "scons --prefix=$out install";

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem";
    homepage = http://rmlint.readthedocs.org;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}
