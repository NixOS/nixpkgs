{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, dbus
, fetchpatch
, sysctl
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.58";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    rev = version;
    hash = "sha256-CwUwwvyT541aIvypVMqRhHkVJLna121Cme+v7c0FLWo=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  nativeCheckInputs = [
    dbus
    # required as the sysctl test works on some machines
    sysctl
  ];

  patches = [
    # /proc/sys/net/core/somaxconn doesn't always exist in the nix build environment
    (fetchpatch {
      name = "skip-sysctl-test-if-sysfs-not-available.patch";
      url = "https://patchwork.kernel.org/project/ell/patch/526DA75D-01AB-4D85-BF5C-5F25E5C39480@kloenk.dev/raw/";
      hash = "sha256-YYGYWQ67cbMLt6RnqZmHt+tpvVIDKPbSCqPIouk6alU=";
    })
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
    maintainers = with maintainers; [ mic92 dtzWill amaxine ];
  };
}
