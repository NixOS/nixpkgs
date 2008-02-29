{stdenv, fetchurl, attr}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "libcap-2.07";
  
  src = fetchurl {
    url = mirror://kernel/linux/libs/security/linux-privs/kernel-2.6/libcap-2.07.tar.gz;
    sha256 = "1zz8nyqzb15lf31akwyzzfdhyhf9xvl9rqih90m9kypmcmc4yz5q";
  };
  
  buildInputs = [attr];

  preBuild = ''
    makeFlagsArray=(LIBDIR=$out/lib INCDIR=$out/include SBINDIR=$out/sbin MANDIR=$out/man)
  '';
}
