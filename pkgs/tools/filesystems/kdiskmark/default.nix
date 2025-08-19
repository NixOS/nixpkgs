{
  stdenv,
  lib,
  wrapQtAppsHook,
  qtbase,
  qttools,
  fio,
  cmake,
  polkit-qt-1,
  extra-cmake-modules,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "kdiskmark";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "jonmagon";
    repo = "kdiskmark";
    rev = version;
    hash = "sha256-b42PNUrG10RyGct6dPtdT89oO222tEovkSPoRcROfaQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    polkit-qt-1
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \$\{POLKITQT-1_POLICY_FILES_INSTALL_DIR\} $out/share/polkit-1/actions
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ fio ])
  ];

  meta = with lib; {
    description = "HDD and SSD benchmark tool with a friendly graphical user interface";
    longDescription = ''
      If kdiskmark is not run as root it can rely on polkit to get the necessary
      privileges. In this case you must install it with `environment.systemPackages`
      on NixOS, nix-env will not work.
    '';
    homepage = "https://github.com/JonMagon/KDiskMark";
    maintainers = [ maintainers.symphorien ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "kdiskmark";
  };
}
