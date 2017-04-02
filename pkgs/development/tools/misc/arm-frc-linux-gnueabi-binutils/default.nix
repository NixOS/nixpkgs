{stdenv, fetchurl, glibc, bison, arm-frc-linux-gnueabi-eglibc}:

stdenv.mkDerivation rec {
  _target = "arm-frc-linux-gnueabi";

  version = "2.28";
  name = "${_target}-binutils-${version}";

  meta.priority = 3;

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/binutils/binutils-${version}.tar.bz2";
    sha256 = "369737ce51587f92466041a97ab7d2358c6d9e1b6490b3940eb09fb0a9a6ac88";
  };

  nativeBuildInputs = [ bison arm-frc-linux-gnueabi-eglibc ];
  buildInputs = [ glibc ];

  configureFlags = ''
    --prefix=/
    --target=${_target}
    --with-pkgversion='GNU-Binutils-for-FRC'
    --with-sysroot=/usr/${_target}
    --with-build-sysroot=/usr/${_target}
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

  installPhase = ''
    make DESTDIR=$out install
    rm -rf $out/usr/share/info

    cp -r ${arm-frc-linux-gnueabi-eglibc}/* $out
  '';
}
