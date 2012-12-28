{ stdenv, fetchurl, flex, cracklib, libxcrypt }:

stdenv.mkDerivation rec {
  name = "linux-pam-1.1.6";

  src = fetchurl {
    url = https://fedorahosted.org/releases/l/i/linux-pam/Linux-PAM-1.1.6.tar.bz2;
    sha256 = "1hlz2kqvbjisvwyicdincq7nz897b9rrafyzccwzqiqg53b8gf5s";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = [ cracklib ]
    ++ stdenv.lib.optional
      (!stdenv.isArm && stdenv.system != "mips64el-linux")
      libxcrypt;

  crossAttrs = {
    # Skip libxcrypt cross-building, as it fails for mips and arm
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
