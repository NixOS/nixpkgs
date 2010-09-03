{stdenv, fetchurl, attr, perl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "libcap-2.19";
  
  src = fetchurl {
    url = mirror://kernel/linux/libs/security/linux-privs/kernel-2.6/libcap-2.19.tar.gz;
    sha256 = "0fdsz9j741npvh222f8p1y6l516z9liibiwdpdr3a4zg53m0pw45";
  };
  
  buildNativeInputs = [perl];
  buildInputs = [attr];

  preBuild = ''
    makeFlagsArray=(LIBDIR=$out/lib INCDIR=$out/include SBINDIR=$out/sbin MANDIR=$out/man PAM_CAP=no)
  '';
}
