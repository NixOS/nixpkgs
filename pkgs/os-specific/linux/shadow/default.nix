{ stdenv, fetchurl, pam ? null, glibcCross ? null }:

let
  glibc = if stdenv ? cross
          then glibcCross
          else assert stdenv ? glibc; stdenv.glibc;
in
stdenv.mkDerivation rec {
  name = "shadow-4.1.4.2";

  src = fetchurl {
    url = "http://pkg-shadow.alioth.debian.org/releases/${name}.tar.bz2";
    sha256 = "1449ny7pdnwkavg92wvibapnkgdq5pas38nvl1m5xa37g5m7z64p";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;

  patches = [ ./no-sanitize-env.patch ./su-name.patch ./keep-path.patch ];

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = "export ac_cv_func_setpgrp_void=yes";

  preBuild = assert glibc != null;
    ''
      substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc}/sbin/nscd
    '';

  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
  };
}
