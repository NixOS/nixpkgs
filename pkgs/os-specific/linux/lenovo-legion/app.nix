{
  lib,
  fetchFromGitHub,
  xorg,
  wrapQtAppsHook,
  python3,
  nix-update-script,
  qtbase,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.0.20-unstable-2025-07-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "f559df04cc0705b2b181dfd0404110a4d1d6e2a9";
    hash = "sha256-WXGDlykH6aBUVotmDcGZ8Y/zC8iBAv57u3hXRnfTaSo=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  build-system = with python3.pkgs; [
    setuptools
    wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    pyqt6
    qtbase
    argcomplete
    pillow
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Utility to control Lenovo Legion laptop";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ulrikstrid
      logger
      chn
    ];
    mainProgram = "legion_gui";
  };
}
