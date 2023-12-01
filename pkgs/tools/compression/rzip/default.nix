{ lib, stdenv, fetchurl, fetchpatch, bzip2 }:

stdenv.mkDerivation rec {
  pname = "rzip";
  version = "2.1";

  src = fetchurl {
    url = "mirror://samba/rzip/rzip-${version}.tar.gz";
    sha256 = "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7";
  };
  buildInputs = [ bzip2 ];

  patches = [
    (fetchpatch {
      name = "CVE-2017-8364-fill-buffer.patch";
      url = "https://sources.debian.net/data/main/r/rzip/2.1-4.1/debian/patches/80-CVE-2017-8364-fill-buffer.patch";
      sha256 = "0jcjlx9ksdvxvjyxmyzscx9ar9992iy5icw0sc3n0p09qi4d6x1r";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-int";

  meta = with lib; {
    homepage = "https://rzip.samba.org/";
    description = "Compression program";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "rzip";
  };
}
