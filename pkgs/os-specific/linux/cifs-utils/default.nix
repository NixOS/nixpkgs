{ stdenv, lib, fetchurl, autoreconfHook, docutils, pkgconfig
, kerberos, keyutils, pam, talloc }:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
  version = "6.9";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "175cp509wn1zv8p8mv37hkf6sxiskrsxdnq22mhlsg61jazz3n0q";
  };

  nativeBuildInputs = [ autoreconfHook docutils pkgconfig ];

  buildInputs = [ kerberos keyutils pam talloc ];

  configureFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  makeFlags = [ "root_sbindir=$(out)/sbin" ];

  meta = with lib; {
    homepage = "http://www.samba.org/linux-cifs/cifs-utils/";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
