{ lib, fetchFromGitHub, xorg, libsForQt5, wrapQtAppsHook, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "v${version}-prerelese";
    hash = "sha256-P4vqzNX2nF4LnoQDOV8WEiXAICQCyjj9xPpFNvMu93k=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    argcomplete
    pyyaml
    darkdetect
    xorg.libxcb
    libsForQt5.qtbase
  ];

  postPatch = ''
    substituteInPlace ./setup.cfg \
      --replace "_VERSION" "${version}"
    substituteInPlace ../../extra/service/fancurve-set \
      --replace "FOLDER=/etc/legion_linux/" "FOLDER=$out/share/legion_linux"
    substituteInPlace ./legion_linux/legion.py \
      --replace "/etc/legion_linux" "$out/share/legion_linux"
  '';

  postInstall = ''
    cp ./legion_linux/legion_logo.png $out/${python3.sitePackages}/legion_logo.png
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

