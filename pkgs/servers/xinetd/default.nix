{ lib, fetchurl, fetchpatch, stdenv, libtirpc, pkgconfig }:

stdenv.mkDerivation rec {
  name = "xinetd-2.3.15";

  src = fetchurl {
    url = "http://www.xinetd.org/${name}.tar.gz";
    sha256 = "1qsv1al506x33gh92bqa8w21k7mxqrbsrwmxvkj0amn72420ckmz";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-apps/xinetd/files/xinetd-2.3.15-creds.patch?id=426002bfe2789fb6213fba832c8bfee634d68d02";
      name = "CVE-2013-4342.patch";
      sha256 = "1iqcrqzgisz4b6vamprzg2y6chai7qpifqcihisrwbjwbc4wzj8v";
    })
  ] ++ lib.optional (stdenv.hostPlatform.isMusl) ./xinetd-musl.patch
    ++ lib.optional (stdenv.hostPlatform.config != stdenv.buildPlatform.config) ./xinetd-cross.patch;

  postPatch = lib.optionalString (stdenv.hostPlatform.config != stdenv.buildPlatform.config) ''
    substituteInPlace libs/src/portable/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
    substituteInPlace libs/src/sio/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
    substituteInPlace libs/src/str/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
    substituteInPlace libs/src/misc/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
    substituteInPlace libs/src/pset/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
    substituteInPlace libs/src/xlog/Makefile.in --replace @ar@ ${stdenv.cc.targetPrefix}ar
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
         substituteInPlace xinetd/Makefile.in --replace @LIBS@ "`pkg-config --libs libtirpc` @LIBS@" --replace @CFLAGS@ "`pkg-config --cflags libtirpc`"
         echo $NIX_CFLAGS_COMPILE
       '';

  buildInputs = lib.optional (stdenv.hostPlatform.isMusl) libtirpc;
  nativeBuildInputs = lib.optional (stdenv.hostPlatform.isMusl) pkgconfig;

  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.isMusl) "-isystem ${libtirpc}/include/tirpc";

  meta = {
    description = "Secure replacement for inetd";
    platforms = stdenv.lib.platforms.linux;
    homepage = http://xinetd.org;
    license = stdenv.lib.licenses.free;
  };
}
