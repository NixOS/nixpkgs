{ stdenv, fetchurl, flex, cracklib }:

stdenv.mkDerivation rec {
  name = "linux-pam-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "http://www.linux-pam.org/library/Linux-PAM-${version}.tar.bz2";
    sha256 = "1n9lnf9gjs72kbj1g354v1xhi2j27aqaah15vykh7cnkq08i4arl";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = [ cracklib ];

  crossAttrs = {
    propagatedBuildInputs = [ flex.crossDrv cracklib.crossDrv ];
    preConfigure = preConfigure + ''
      ar x ${flex.crossDrv}/lib/libfl.a
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
