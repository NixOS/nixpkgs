{ lib, stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs, argp-standalone }:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  pname = "elfutils";
  version = "0.180";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
    sha256 = "17an1f67bfzxin482nbcxdl5qvywm27i9kypjyx8ilarbkivc9xq";
  };

  patches = [ ./debug-info-from-env.patch ];

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ];
  buildInputs = [ zlib bzip2 xz ]
    ++ lib.optional stdenv.hostPlatform.isMusl argp-standalone;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -fgnu89-inline"
  '';

  configureFlags =
    [ "--program-prefix=eu-" # prevent collisions with binutils
      "--enable-deterministic-archives"
      "--disable-debuginfod"
    ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 out of 174 tests
  doInstallCheck = false; # fails 70 out of 174 tests

  meta = {
    homepage = "https://sourceware.org/elfutils/";
    description = "A set of utilities to handle ELF objects";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.eelco ];
  };
}
