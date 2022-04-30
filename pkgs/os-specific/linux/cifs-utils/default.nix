{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, docutils, pkg-config
, libkrb5, keyutils, pam, talloc, python3 }:

stdenv.mkDerivation rec {
  pname = "cifs-utils";
  version = "6.14";

  src = fetchurl {
    url = "mirror://samba/pub/linux-cifs/cifs-utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ZgnoB0tUISlf8BKjHwLM2aBYQVxhnIE2Lrt4jb8HVrg=";
  };

  patches = [
    (fetchpatch {
      # Fix buffer-overflow in handling of ip= parameter in mount.cifs
      # https://www.openwall.com/lists/oss-security/2022/04/27/5
      name = "CVE-2022-27239.patch";
      url = "https://github.com/piastry/cifs-utils/commit/007c07fd91b6d42f8bd45187cf78ebb06801139d.patch";
      sha256 = "sha256-3uoHso2q17r2bcEW+ZjYUWsW4OIGYA7kxYZxQQy0JOg=";
    })
    (fetchpatch {
      # Fix disclosure of invalid credential configuration in verbose mode
      name = "CVE-2022-29869.patch";
      url = "https://github.com/piastry/cifs-utils/commit/8acc963a2e7e9d63fe1f2e7f73f5a03f83d9c379.patch";
      sha256 = "sha256-MjfreeL1ME550EYK9LPOUAAjIk1BoMGfb+pQe3A1bz8=";
    })
  ];

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
