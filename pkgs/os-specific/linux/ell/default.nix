{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.36";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/${pname}/${pname}.git";
    rev = version;
    sha256 = "0w7v2hihwwmnqd56bsmbjsiw8yyadr7zbdssjamqxx0pyl3dnrda";
  };

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
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
