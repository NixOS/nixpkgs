{stdenv, fetchurl, glibc, bison, arm-frc-linux-gnueabi-eglibc}:

stdenv.mkDerivation rec {
  _target = "arm-frc-linux-gnueabi";

  version = "2.28";
  name = "${_target}-binutils-${version}";

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "369737ce51587f92466041a97ab7d2358c6d9e1b6490b3940eb09fb0a9a6ac88";
  };

  nativeBuildInputs = [ bison arm-frc-linux-gnueabi-eglibc ];
  buildInputs = [ glibc ];

  configureFlags = ''
    --target=${_target}
    --with-pkgversion='GNU-Binutils-for-FRC'
    --with-sysroot=$out/${_target}
    --with-build-sysroot=/$out/${_target}
    --disable-multilib
    --disable-nls
    --enable-lto
    --disable-libiberty-install
    --enable-ld
    --enable-gold=default
    --enable-plugins
  '';

  postConfigure = ''
    make configure-host
  '';

  postInstall = ''
    rm -rf $out/share/info
  '';

  meta = {
    description = "FRC binutils";
    longDescription = ''
      binutils used to build arm-frc-linux-gnueabi and user programs.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.colescott ];
    platforms = stdenv.lib.platforms.linux;

    priority = 3;
  };
}
