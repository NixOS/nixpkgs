{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "which";
  version = "2.21";

  src = fetchurl {
    url = "mirror://gnu/which/which-${version}.tar.gz";
    sha256 = "1bgafvy3ypbhhfznwjv1lxmd6mci3x1byilnnkc7gcr486wlb8pl";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString (
    # Enable 64-bit file API. Otherwise `which` fails to find tools
    # on filesystems with 64-bit inodes (like `btrfs`) when running
    # binaries from 32-bit systems (like `i686-linux`).
    lib.optional stdenv.hostPlatform.is32bit "-D_FILE_OFFSET_BITS=64"
  );

  meta = with lib; {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
