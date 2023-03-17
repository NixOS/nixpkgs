{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, dbus
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.56";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    rev = version;
    sha256 = "sha256-aCQ7I4XgxswQRfzzZG3MYe+W3dPWWex5MErMc0ZilSA=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  nativeCheckInputs = [
    dbus
  ];

  enableParallelBuilding = true;

  # tests sporadically fail on musl
  doCheck = !stdenv.hostPlatform.isMusl;

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    changelog = "https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ChangeLog?h=${version}";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill maxeaubrey ];
  };
}
