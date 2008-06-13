{stdenv, fetchurl, attr}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "libcap-2.09";
  
  src = fetchurl {
    url = mirror://kernel/linux/libs/security/linux-privs/kernel-2.6/libcap-2.09.tar.bz2;
    sha256 = "0sq15y8yfm7knf6jhqcycb9wz52n3r1sriii66xk0djvd4hw69jr";
  };
  
  buildInputs = [attr];

  preBuild = ''
    makeFlagsArray=(LIBDIR=$out/lib INCDIR=$out/include SBINDIR=$out/sbin MANDIR=$out/man PAM_CAP=no)
  '';
}
