{ lib, stdenv
, fetchgit
, autoreconfHook
, pkgconfig
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.35";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
    rev = version;
    sha256 = "16z7xwlrpx1bsr2y1rgxxxixzwc84cwn2g557iqxhwsxfzy6q3dk";
  };

  patches = [
    # Sent upstream in https://lists.01.org/hyperkitty/list/ell@lists.01.org/thread/SQEZAIS2LZXSXGTXOW3GTAM5ZPXRLTN4/
    ./0001-unit-test-dbus-pick-up-dbus-daemon-from-PATH.patch
  ];

  nativeBuildInputs = [
    pkgconfig
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
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
