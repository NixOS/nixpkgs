{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  capstone_4,
  double-conversion,
  graphviz,
  qtxmlpatterns,
  qttools,
  qtbase,
  wrapQtAppsHook,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edb";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "eteran";
    repo = "edb-debugger";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-ALhA/odVwUQHKuOZ1W/i/6L7da/yitdpBsx2kz2ySQE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    qtbase
    boost.dev
    capstone_4
    double-conversion
    graphviz
    qtxmlpatterns
  ];

  cmakeFlags = [
    (lib.cmakeFeature "DEFAULT_PLUGIN_DIR" "${placeholder "out"}/lib/edb")
  ];

  postPatch = ''
    # The build script checks for the presence of .git to determine whether
    # submodules were fetched and will throw an error if it's not there.
    # Avoid using leaveDotGit in the fetchFromGitHub options as it is non-deterministic.
    mkdir -p src/qhexview/.git lib/gdtoa-desktop/.git
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "env QT_QPA_PLATFORM=minimal ${lib.getExe finalAttrs.finalPackage} --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross platform AArch32/x86/x86-64 debugger";
    mainProgram = "edb";
    homepage = "https://github.com/eteran/edb-debugger";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      lihop
      maxxk
    ];
    platforms = [ "x86_64-linux" ];
  };
})
