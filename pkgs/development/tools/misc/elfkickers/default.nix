{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  version = "3.1a";

  src = fetchurl {
    url = "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
    sha256 = "02354yn1lh1dxny35ky2d0b44iq302krsqpwk5grr4glma00hhq6";
  };

  makeFlags = [ "CC=cc prefix=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.muppetlabs.com/~breadbox/software/elfkickers.html;
    description = "A collection of programs that access and manipulate ELF files";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.dtzWill ];
  };
}
