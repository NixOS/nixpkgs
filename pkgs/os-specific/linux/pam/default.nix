{ stdenv, fetchurl, flex, cracklib, libxcrypt }:

stdenv.mkDerivation {
  name = "linux-pam-1.1.1";

  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/library/Linux-PAM-1.1.1.tar.bz2;
    sha256 = "015r3xdkjpqwcv4lvxavq0nybdpxhfjycqpzbx8agqd5sywkx3b0";
  };

  buildInputs = [ flex cracklib ]
    ++ stdenv.lib.optional (stdenv.system != "armv5tel-linux") libxcrypt;

  postInstall = ''
    mv -v $out/sbin/unix_chkpwd{,.orig}
    ln -sv /var/setuid-wrappers/unix_chkpwd $out/sbin/unix_chkpwd
    '';

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$out/include/security"
  '';

  meta = {
    homepage = http://ftp.kernel.org/pub/linux/libs/pam/;
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = stdenv.lib.platforms.linux;
  };
}
