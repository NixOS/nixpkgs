{ lib, stdenv, fetchurl, pkg-config, fuse, libmtp, glib, libmad, libid3tag }:

stdenv.mkDerivation rec {
  pname = "mtpfs";
  version = "1.1";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse libmtp glib libid3tag libmad ];

  # adding LIBS is a hack, duno why it does not find libid3tag.so by adding buildInputs
  preConfigure = ''
    export MAD_CFLAGS=${libmad}/include
    export MAD_LIBS=${libmad}/lib/libmad.so
    export LIBS=${libid3tag}/lib/libid3tag.so
  '';

  src = fetchurl {
    url = "https://www.adebenham.com/files/mtp/mtpfs-${version}.tar.gz";
    sha256 = "07acrqb17kpif2xcsqfqh5j4axvsa4rnh6xwnpqab5b9w5ykbbqv";
  };

  meta = with lib; {
    homepage = "https://github.com/cjd/mtpfs";
    description = "FUSE Filesystem providing access to MTP devices";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = [ maintainers.qknight ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/mtpfs.x86_64-darwin
  };
}
