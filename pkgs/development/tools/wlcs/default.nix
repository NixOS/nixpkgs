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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "wlcs";
    rev = "v${version}";
    hash = "sha256-QxmWxu+w77/WE5pGXMWXm+NP95QmYo2O8ltZYrgCIWw=";
  };

  patches = [
    # Improves pkg-config paths even more
    # Remove when https://github.com/MirServer/wlcs/pull/260 merged & in a release
    (fetchpatch {
      name = "0001-wlcs-pkgsconfig-Use-better-path-concatenations.patch";
      url = "https://github.com/MirServer/wlcs/pull/260/commits/20f28d82fa4dfa6a6e27212dbd6b0f2e8a833c69.patch";
      hash = "sha256-m8zPD27JbX/vN2YQgNhcRsh/O+qLfvoeky5E5ZEeD1I=";
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

  NIX_CFLAGS_COMPILE = [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
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
    platforms = platforms.linux;
  };
}
