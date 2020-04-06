{ lib, stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext, xz, setupDebugInfoDirs }:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  pname = "elfutils";
  version = "0.176";

  src = fetchurl {
    url = "https://sourceware.org/elfutils/ftp/${version}/${pname}-${version}.tar.bz2";
    sha256 = "08qhrl4g6qqr4ga46jhh78y56a47p3msa5b2x1qhzbxhf71lfmzb";
  };

  patches = [ ./debug-info-from-env.patch ];

  hardeningDisable = [ "format" ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [ m4 bison flex gettext bzip2 ];
  buildInputs = [ zlib bzip2 xz ];

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  configureFlags =
    [ "--program-prefix=eu-" # prevent collisions with binutils
      "--enable-deterministic-archives"
    ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 out of 174 tests
  doInstallCheck = false; # fails 70 out of 174 tests

  meta = {
    homepage = https://sourceware.org/elfutils/;
    description = "A set of utilities to handle ELF objects";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.eelco ];
  };
}
