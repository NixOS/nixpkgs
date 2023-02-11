{lib, stdenv, fetchurl, libvorbis, libmad, pkg-config, libao}:

stdenv.mkDerivation rec {
  pname = "cdrdao";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/cdrdao/cdrdao-${version}.tar.bz2";
    sha256 = "0pmpgx91j984snrsxbq1dgf3ximks2dfh1sqqmic72lrls7wp4w1";
  };

  makeFlags = [ "RM=rm" "LN=ln" "MV=mv" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvorbis libmad libao ];

  hardeningDisable = [ "format" ];

  # Adjust some headers to match glibc 2.12 ... patch is a diff between
  # the cdrdao CVS head and the 1.2.3 release.
  patches = [ ./adjust-includes-for-glibc-212.patch ];

  # we have glibc/include/linux as a symlink to the kernel headers,
  # and the magic '..' points to kernelheaders, and not back to the glibc/include
  postPatch = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  # Needed on gcc >= 6.
  NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = with lib; {
    description = "A tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = "https://cdrdao.sourceforge.net/";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
