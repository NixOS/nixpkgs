{ stdenv, fetchurl, pkgconfig, automake, autoconf, udisks1, dbus-glib, glib, libconfuse }:

stdenv.mkDerivation {
  name = "udisks-glue-1.3.5";

  src = fetchurl {
    url = "https://github.com/fernandotcl/udisks-glue/archive/release-1.3.5.tar.gz";
    sha256 = "317d25bf249278dc8f6a5dcf18f760512427c772b9afe3cfe34e6e1baa258176";
  };

  nativeBuildInputs = [ pkgconfig automake autoconf ];
  buildInputs = [ udisks1 dbus-glib glib libconfuse ];

  preConfigure = "sh autogen.sh";

  meta = {
    homepage = "https://github.com/fernandotcl/udisks-glue";
    description = "A tool to associate udisks events to user-defined actions";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [pSub];
    license = stdenv.lib.licenses.bsd2;
    broken = true;
    hydraPlatforms = [];
  };
}
