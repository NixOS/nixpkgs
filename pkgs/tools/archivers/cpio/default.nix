{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook

# for passthru.tests
, git
, libguestfs
, nixosTests
, rpm
}:

stdenv.mkDerivation rec {
  pname = "cpio";
  version = "2.14";

  src = fetchurl {
    url = "mirror://gnu/cpio/cpio-${version}.tar.bz2";
    sha256 = "/NwV1g9yZ6b8fvzWudt7bIlmxPL7u5ZMJNQTNv0/LBI=";
  };

  patches = [
    # Pull upstream fix for clang-16 and gcc-14.
    (fetchpatch {
      name = "major-decl.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=8179be21e664cedb2e9d238cc2f6d04965e97275";
      hash = "sha256-k5Xiv3xuPU8kPT6D9B6p+V8SK55ybFgrIIPDgHuorpM=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  separateDebugInfo = true;

  preConfigure = lib.optionalString stdenv.isCygwin ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit libguestfs rpm;
    git = git.tests.withInstallCheck;
    initrd = nixosTests.systemd-initrd-simple;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/cpio/";
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
    mainProgram = "cpio";
  };
}
