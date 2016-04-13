{stdenv, fetchurl, glibc}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "dietlibc-0.30";
  src = fetchurl {
    url = mirror://kernel/linux/libs/dietlibc/dietlibc-0.30.tar.bz2;
    md5 = "2465d652fff6f1fad3da3b98e60e83c9";
  };
  builder = ./builder.sh;
  
  inherit glibc;
  kernelHeaders = glibc.linuxHeaders;

  patches = [

    # dietlibc's sigcontext.h provides a macro called PC(), which is
    # rather intrusive (e.g., binutils fails to compile because of
    # it).  Rename it.
    ./pc.patch

    # wchar.h declares lots of functions that don't actually exist.
    # Remove them.
    ./no-wchar.patch

    # Fix to get DNS resolution to work on 64-bit platforms.  Taken
    # from 0.31 CVS.
    ./dns64.patch

    # Get lseek64 working on x86_64.  From
    # http://svn.annvix.org/cgi-bin/viewvc.cgi/packages/releases/2.0-CURRENT/dietlibc/SOURCES
    ./x86_64-lseek64.patch
    #./x86_64-stat64.patch

  ];

  meta = {
    homepage = http://www.fefe.de/dietlibc/;
    description = "A small implementation of the C library";
    license = "GPL";
  };
}
