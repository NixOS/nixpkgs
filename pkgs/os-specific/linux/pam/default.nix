{ stdenv, fetchurl, flex, cracklib, libxcrypt }:

stdenv.mkDerivation {
  name = "linux-pam-1.1.1";

  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/library/Linux-PAM-1.1.1.tar.bz2;
    sha256 = "015r3xdkjpqwcv4lvxavq0nybdpxhfjycqpzbx8agqd5sywkx3b0";
  };

  buildInputs = [ flex cracklib ]
    ++ stdenv.lib.optional
      (stdenv.system != "armv5tel-linux" && stdenv.system != "ict_loongson-2_v0.3_fpu_v0.1-linux")
      libxcrypt;

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$out/include/security"
  '';
}
