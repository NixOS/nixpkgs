{ stdenv, fetchurl, flex, cracklib, libxcrypt }:

stdenv.mkDerivation rec {
  name = "linux-pam-1.1.1";

  src = fetchurl {
    url = mirror://kernel/linux/libs/pam/library/Linux-PAM-1.1.1.tar.bz2;
    sha256 = "015r3xdkjpqwcv4lvxavq0nybdpxhfjycqpzbx8agqd5sywkx3b0";
  };

  buildNativeInputs = [ flex ];
  buildInputs = [ cracklib ]
    ++ stdenv.lib.optional
      (stdenv.system != "armv5tel-linux" && stdenv.system != "mips64-linux")
      libxcrypt;

  crossAttrs = {
    # Skip libxcrypt cross-building, as it fails for mips and armv5tel
    propagatedBuildInputs = [ flex.hostDrv cracklib.hostDrv ];
    preConfigure = preConfigure + ''
      ar x ${flex.hostDrv}/lib/libfl.a
      mv libyywrap.o libyywrap-target.o
      ar x ${flex}/lib/libfl.a
      mv libyywrap.o libyywrap-host.o
      export LDFLAGS="$LDFLAGS $PWD/libyywrap-target.o"
      sed -e 's/@CC@/gcc/' -i doc/specs/Makefile.in
    '';
    postConfigure = ''
      sed -e "s@ $PWD/libyywrap-target.o@ $PWD/libyywrap-host.o@" -i doc/specs/Makefile
    ''; 
  };

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
