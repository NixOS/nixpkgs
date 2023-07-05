{ lib, fetchFromGitHub, xorg, libsForQt5, wrapQtAppsHook, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "2023-04-02-16-53-51";

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "main${version}";
    sha256 = "sha256-s4JFFmawokdC4qoqNvZDhuJSinhQ3YKSIfAYi79VTTA=";
  };

  sourceRoot = "source/python/legion_linux";

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    argcomplete
    pyyaml
    xorg.libxcb
    libsForQt5.qtbase
  ];

  postInstall = ''
    cp -r ./{legion.py,legion_cli.py,legion_gui.py} $out/${python3.sitePackages}
    cp ./legion_logo.png $out/${python3.sitePackages}/legion_logo.png

    rm -rf $out/data
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "An utility to control Lenovo Legion laptop";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ulrikstrid ];
    mainProgram = "legion_gui";
  };
}

