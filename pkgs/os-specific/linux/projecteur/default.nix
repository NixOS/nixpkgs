{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qtbase,
  qtgraphicaleffects,
  wrapQtAppsHook,
  udevCheckHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projecteur";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "jahnf";
    repo = "Projecteur";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = false;
    hash = "sha256-F7o93rBjrDTmArTIz8RB/uGBOYE6ny/U7ppk+jEhM5A=";
  };

  buildInputs = [
    qtbase
    qtgraphicaleffects
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    udevCheckHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX:PATH=${placeholder "out"}"
    "-DPACKAGE_TARGETS=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Linux/X11 application for the Logitech Spotlight device (and similar devices)";
    homepage = "https://github.com/jahnf/Projecteur";
    license = lib.licenses.mit;
    mainProgram = "projecteur";
    maintainers = with lib.maintainers; [
      benneti
    ];
    platforms = lib.platforms.linux;
  };
})
