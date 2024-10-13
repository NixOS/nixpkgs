{
  lib,
  fetchFromGitHub,
  xorg,
  libsForQt5,
  wrapQtAppsHook,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "v${version}";
    hash = "sha256-Tn94oW400XMwWde1G3OR7Eyrc0LVPAo9UA1daIChjVo=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    pyqt6
    argcomplete
    pyyaml
    darkdetect
    xorg.libxcb
    libsForQt5.qtbase
  ];

  postPatch = ''
    substituteInPlace ./setup.cfg \
      --replace-fail "_VERSION" "${version}"
    substituteInPlace ./legion_linux/legion.py \
      --replace-fail "/etc/legion_linux" "$out/share/legion_linux"
    substituteInPlace ./legion_linux/legion_gui.desktop \
      --replace-fail "Icon=/usr/share/pixmaps/legion_logo.png" "Icon=legion_logo"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Utility to control Lenovo Legion laptop";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ulrikstrid
      realsnick
    ];
    mainProgram = "legion_gui";
  };
}
