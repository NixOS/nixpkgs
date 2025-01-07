{ lib
, stdenv
, fetchurl
, autoreconfHook

# for passthru.tests
, git
, libguestfs
, nixosTests
, rpm
}:

stdenv.mkDerivation rec {
  pname = "cpio";
  version = "2.15";

  src = fetchurl {
    url = "mirror://gnu/cpio/cpio-${version}.tar.bz2";
    hash = "sha256-k3YQuXwymh7JJoVT+3gAN7z/8Nz/6XJevE/ZwaqQdds=";
  };

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
    description = "Program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
    mainProgram = "cpio";
  };
}
