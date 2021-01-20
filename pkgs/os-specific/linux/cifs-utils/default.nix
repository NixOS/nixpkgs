{ stdenv, lib, fetchurl, autoreconfHook, docutils, pkg-config
, kerberos, keyutils, pam, talloc }:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
  version = "6.12";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "1vw570pvir73kl4y6fhd6ns936ankimkhb1ii43yh8lr0p1xqbcj";
  };

  nativeBuildInputs = [ autoreconfHook docutils pkg-config ];

  buildInputs = [ kerberos keyutils pam talloc ];

  configureFlags = [ "ROOTSBINDIR=$(out)/sbin" ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = with lib; {
    homepage = "https://wiki.samba.org/index.php/LinuxCIFS_utils";
    description = "Tools for managing Linux CIFS client filesystems";
    platforms = platforms.linux;
    license = licenses.lgpl3;
  };
}
