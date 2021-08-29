{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, fuse }:

stdenv.mkDerivation {
  name = "afuse-0.4.1";

  src = fetchurl {
    url = "https://github.com/pcarrier/afuse/archive/v0.4.1.tar.gz";
    sha256 = "1sfhicmxppkvdd4z9klfn63snb71gr9hff6xij1gzk94xg6m0ycc";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix the build on macOS with macFUSE installed
    substituteInPlace configure.ac --replace \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' \
      ""
  '';

  meta = {
    description = "Automounter in userspace";
    homepage = "https://github.com/pcarrier/afuse";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.unix;
  };
}
