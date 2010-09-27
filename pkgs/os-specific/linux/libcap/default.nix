{stdenv, fetchurl, attr, perl, pam}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "libcap-2.19";
  
  src = fetchurl {
    url = mirror://kernel/linux/libs/security/linux-privs/kernel-2.6/libcap-2.19.tar.gz;
    sha256 = "0fdsz9j741npvh222f8p1y6l516z9liibiwdpdr3a4zg53m0pw45";
  };
  
  buildNativeInputs = [perl];
  buildInputs = [attr pam];

  makeFlags = "PAM_CAP=yes lib=lib prefix=$(out)";
}
