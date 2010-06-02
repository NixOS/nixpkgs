{ stdenv, fetchurl, flex, cracklib, libxcrypt }:

stdenv.mkDerivation {
  name = "linux-pam-1.1.1";

  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/library/Linux-PAM-1.1.1.tar.bz2;
    sha256 = "015r3xdkjpqwcv4lvxavq0nybdpxhfjycqpzbx8agqd5sywkx3b0";
  };

  buildInputs = [ flex cracklib libxcrypt ];

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$out/include/security"
  '';
}
