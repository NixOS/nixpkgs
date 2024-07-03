{ lib, stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkg-config
, dbus
, sysctl
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ell";
  version = "0.66";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    rev = version;
    hash = "sha256-FqJbAE2P6rKKUMwcDShCKNDQu4RRifEGrbE7F4gSpm0=";
  };

  patches = [
    # Without the revert TCP dbus tests fail to bind the port and fail.
    # Seemingly a known dbus bug: https://gitlab.freedesktop.org/dbus/dbus/-/issues/28
    (fetchpatch {
      name = "revert-tcp-tests.patch";
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git/patch/?id=7863e06b18b9cce56392b65928e927297108337d";
      hash = "sha256-8+M1k0hGE64CHmK1T5/zW8+Q76pIjl5SMaYktRqpudg=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  nativeCheckInputs = [
    dbus
    # required as the sysctl test works on some machines
    sysctl
  ];

  enableParallelBuilding = true;

  # tests sporadically fail on musl
  doCheck = !stdenv.hostPlatform.isMusl;

  passthru = {
    updateScript = gitUpdater {
      url = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    };
  };

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/libs/ell/ell.git";
    description = "Embedded Linux Library";
    longDescription = ''
      The Embedded Linux* Library (ELL) provides core, low-level functionality for system daemons. It typically has no dependencies other than the Linux kernel, C standard library, and libdl (for dynamic linking). While ELL is designed to be efficient and compact enough for use on embedded Linux platforms, it is not limited to resource-constrained systems.
    '';
    changelog = "https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ChangeLog?h=${version}";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 dtzWill ];
  };
}
