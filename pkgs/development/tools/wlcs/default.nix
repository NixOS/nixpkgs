{ stdenv
, lib
, gitUpdater
, fetchFromGitHub
, testers
, cmake
, pkg-config
, boost
, gtest
, wayland
, wayland-scanner
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlcs";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "wlcs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BQPRymkbGu4YvTYXTaTMuyP5fHpqMWI4xPwjDRHZNEQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    boost
    gtest
    wayland
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
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
    pkgConfigModules = [
      "wlcs"
    ];
  };
})
