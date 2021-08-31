{ lib, stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkg-config
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.42";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
    rev = version;
    sha256 = "sha256-GgQhSzVqGCpljWewtevCc9rpkks7devRNp5TN+5JNN4=";
  };
  patches = [
    (fetchpatch {
      name = "fix-test-cipher-without-AF_ALG-kernel.patch";
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git/patch/?id=6b18c5d0128fbb8cea19a4622429a75ed992ba69";
      sha256 = "sha256-yg8RtQ26V+pr44MH7JN2GypFiHmEbdF5AeJabqRAVZw=";
    })
    (fetchpatch {
      name = "fix-test-uuid-without-AF_ALG-kernel.patch";
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git/patch/?id=093c8122c7aa3543c89fa8f5056660903ad241d1";
      sha256 = "sha256-iShbf3lhFES537deCk21FixN+uzJUGXB31JukTHH6zk=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  checkInputs = [
    dbus
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://01.org/ell";
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill maxeaubrey ];
  };
}
