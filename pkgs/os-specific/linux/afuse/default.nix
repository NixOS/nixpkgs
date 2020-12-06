{ stdenv, fetchurl, pkgconfig, autoreconfHook, fuse }:

stdenv.mkDerivation {
  name = "afuse-0.4.1";

  src = fetchurl {
    url = "https://github.com/pcarrier/afuse/archive/v0.4.1.tar.gz";
    sha256 = "1sfhicmxppkvdd4z9klfn63snb71gr9hff6xij1gzk94xg6m0ycc";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fuse ];

  meta = {
    description = "Automounter in userspace";
    homepage = "https://github.com/pcarrier/afuse";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
