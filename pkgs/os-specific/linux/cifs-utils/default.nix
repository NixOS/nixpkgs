{ stdenv, lib, fetchurl, autoreconfHook, docutils, pkg-config
, libkrb5, keyutils, pam, talloc, python3 }:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
  version = "7.1";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ohEj92pKajbJZTGJukkY6988/NP5CScwpH/zRQtbWyo=";
  };

  nativeBuildInputs = [ autoreconfHook docutils pkg-config ];

  buildInputs = [ libkrb5 keyutils pam talloc python3 ];

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
