{ stdenv
, lib
, wrapQtAppsHook
, qtbase
, qttools
, fio
, cmake
, polkit-qt
, extra-cmake-modules
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "kdiskmark";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "jonmagon";
    repo = "kdiskmark";
    rev = version;
    hash = "sha256-JueY7zw9PIo9ETi7pQLpw8FGRhNXYXeXEvTzZGz9lbw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    qtbase
    qttools
    extra-cmake-modules
    polkit-qt
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace \$\{POLKITQT-1_POLICY_FILES_INSTALL_DIR\} $out/share/polkit-1/actions
  '';

  qtWrapperArgs =
    [ "--prefix" "PATH" ":" (lib.makeBinPath [ fio ]) ];

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

