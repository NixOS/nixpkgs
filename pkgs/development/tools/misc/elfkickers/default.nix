{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "elfkickers-${version}";
  version = "3.1";

  src = fetchurl {
    url = "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
    sha256 = "0n0sypjrdm3ramv0sby4sdh3i3j9d0ihadr951wa08ypdnq3yrkd";
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
