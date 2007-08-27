{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "libcap-1.10";
  src = fetchurl {
    url = mirror://kernel/linux/libs/security/linux-privs/kernel-2.4/libcap-1.10.tar.bz2;
    md5 = "4426a413128142cab89eb2e6f13d8571";
  };
  
  preBuild = "
    substituteInPlace libcap/Makefile --replace /usr/include ${stdenv.glibc}/include
    makeFlags=\"LIBDIR=$out/lib INCDIR=$out/include SBINDIR=$out/sbin MANDIR=$out/man\"
  ";

  patches = [
    # Borrowed from http://sources.gentoo.org/viewcvs.py/gentoo-x86/sys-libs/libcap/files/libcap-1.10-syscall.patch?rev=1.2&view=log.
    ./syscall.patch
  ];
}
