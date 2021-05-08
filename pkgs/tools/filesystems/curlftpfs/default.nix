{ lib, stdenv, fetchurl, autoreconfHook, fuse, curl, pkg-config, glib, zlib }:

stdenv.mkDerivation {
  name = "curlftpfs-0.9.2";
  src = fetchurl {
    url = "mirror://sourceforge/curlftpfs/curlftpfs-0.9.2.tar.gz";
    sha256 = "0n397hmv21jsr1j7zx3m21i7ryscdhkdsyqpvvns12q7qwwlgd2f";
  };
  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse curl glib zlib ];

  CFLAGS = lib.optionalString stdenv.isDarwin "-D__off_t=off_t";

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix the build on macOS with macFUSE installed. Needs autoreconfHook for
    # this change to effect
    substituteInPlace configure.ac --replace \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' \
      ""
  '';

  doCheck = false; # fails, doesn't work well too, btw

  meta = with lib; {
    description = "Filesystem for accessing FTP hosts based on FUSE and libcurl";
    homepage = "http://curlftpfs.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
