{stdenv, fetchurl, lame, libvorbis, libmad, pkgconfig, libao}:

stdenv.mkDerivation {
  name = "cdrdao-1.2.3";

  src = fetchurl {
    url = mirror://sourceforge/cdrdao/cdrdao-1.2.3.tar.bz2;
    sha256 = "0pmpgx91j984snrsxbq1dgf3ximks2dfh1sqqmic72lrls7wp4w1";
  };

  makeFlags = "RM=rm LN=ln MV=mv";

  buildInputs = [ lame libvorbis libmad pkgconfig libao ];

  # we have glibc/include/linux as a symlink to the kernel headers,
  # and the magic '..' points to kernelheaders, and not back to the glibc/include
  patchPhase = ''
    sed -i 's,linux/../,,g' dao/sg_err.h
  '';

  meta = {
    description = "A tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = http://cdrdao.sourceforge.net/;
  };
}
