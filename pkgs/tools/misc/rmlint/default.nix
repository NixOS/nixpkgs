{ stdenv, fetchurl
, gettext, glib, json_glib, libelf, pkgconfig, scons, sphinx, utillinux }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rmlint-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/sahib/rmlint/archive/v${version}.tar.gz";
    sha256 = "14jiswagipsmzxclcskn672ws4126p65l6hlzkkvanyv8gmpv90f";
  };

  patches = [ ./fix-scons.patch ];

  configurePhase = "scons config";

  buildInputs = [ gettext glib json_glib libelf pkgconfig scons sphinx utillinux ];

  buildPhase = "scons";

  installPhase = "scons --prefix=$out install";

  meta = {
    description = "Extremely fast tool to remove duplicates and other lint from your filesystem.";
    homepage = http://rmlint.readthedocs.org;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.koral ];
  };
}
