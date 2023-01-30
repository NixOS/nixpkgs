{ stdenv
, lib
, gitUpdater
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, boost
, gtest
, wayland
}:

stdenv.mkDerivation rec {
  pname = "wlcs";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "wlcs";
    rev = "v${version}";
    hash = "sha256-ep5BHa9PgfB50gxJySaw0YAc1upBbncOiX9PCqHLbpE=";
  };

  patches = [
    # Fixes pkg-config paths
    # Remove when https://github.com/MirServer/wlcs/pull/258 merged & in a release
    (fetchpatch {
      name = "0001-wlcs-pkgsconfig-use-FULL-install-vars.patch";
      url = "https://github.com/MirServer/wlcs/pull/258/commits/9002cb7323d94aba7fc1ce5927f445e9beb30d70.patch";
      hash = "sha256-+uhFRKhG59w99oES4RA+L5hHyJ5pf4ij97pTokERPys=";
    })
    (fetchpatch {
      name = "0002-wlcs-CMAKE_INSTALL_INCLUDEDIR-for-headers.patch";
      url = "https://github.com/MirServer/wlcs/pull/258/commits/71263172c9ba57be9c05f1e07dd40d1f378ca6d0.patch";
      hash = "sha256-nV/72W9DW3AvNGhUZ+tzmQZow3BkxEH3D6QFBZIGjj8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    gtest
    wayland
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Wayland Conformance Test Suite";
    longDescription = ''
      wlcs aspires to be a protocol-conformance-verifying test suite usable by Wayland
      compositor implementors.

      It is growing out of porting the existing Weston test suite to be run in Mir's
      test suite, but it is designed to be usable by any compositor.

      wlcs relies on compositors providing an integration module, providing wlcs with
      API hooks to start a compositor, connect a client, move a window, and so on.
      This makes both writing and debugging tests easier - the tests are (generally)
      in the same address space as the compositor, so there is a consistent global
      clock available, it's easier to poke around in compositor internals, and
      standard debugging tools can follow control flow from the test client to the
      compositor and back again.
    '';
    homepage = "https://github.com/MirServer/wlcs";
    changelog = "https://github.com/MirServer/wlcs/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    inherit (wayland.meta) platforms;
  };
}
