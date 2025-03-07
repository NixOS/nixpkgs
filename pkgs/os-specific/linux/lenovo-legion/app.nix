{
  lib,
  fetchFromGitHub,
  xorg,
  wrapQtAppsHook,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.0.19-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "43f2ad0ea67b69f509a0c5f0254272fe85f3b070";
    hash = "sha256-k7CHL59tRjfly1xV+TXjNitkhV7q6qtMhuc+QO5ASkI=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt6
    argcomplete
    pyyaml
    darkdetect
    xorg.libxcb
  ];

  postPatch = ''
    # only fixup application (legion-linux-gui), service (legiond) currently not installed so do not fixup
    # version
    substituteInPlace ./setup.cfg \
      --replace-fail "_VERSION" "${builtins.head (lib.splitString "-" version)}"

    # /etc
    substituteInPlace ./legion_linux/legion.py \
      --replace-fail "/etc/legion_linux" "$out/share/legion_linux"

    # /usr
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
      chn
    ];
    mainProgram = "legion_gui";
  };
}
