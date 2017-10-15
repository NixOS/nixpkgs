{ stdenv, buildPackages, fetchurl, flex, cracklib }:

stdenv.mkDerivation rec {
  name = "linux-pam-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://www.linux-pam.org/library/Linux-PAM-${version}.tar.bz2";
    sha256 = "1fyi04d5nsh8ivd0rn2y0z83ylgc0licz7kifbb6xxi2ylgfs6i4";
  };

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  nativeBuildInputs = [ buildPackages.stdenv.cc flex ];

  buildInputs = [ cracklib ];

  enableParallelBuilding = true;

  crossAttrs = {
    propagatedBuildInputs = [ flex.crossDrv cracklib.crossDrv ];
    preConfigure = preConfigure + ''
      $crossConfig-ar x ${flex.crossDrv}/lib/libfl.a
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
    ln -sv /run/wrappers/bin/unix_chkpwd $out/sbin/unix_chkpwd
  ''; /*
    rm -rf $out/etc
    mkdir -p $modules/lib
    mv $out/lib/security $modules/lib/
  '';*/
  # don't move modules, because libpam needs to (be able to) find them,
  # which is done by dlopening $out/lib/security/pam_foo.so
  # $out/etc was also missed: pam_env(login:session): Unable to open config file

  preConfigure = ''
    configureFlags="$configureFlags --includedir=$out/include/security"
  '';

  meta = {
    homepage = http://ftp.kernel.org/pub/linux/libs/pam/;
    description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
    platforms = stdenv.lib.platforms.linux;
  };
}
