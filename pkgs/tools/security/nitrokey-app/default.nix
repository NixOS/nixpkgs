{ lib
, stdenv
, cmake
, fetchFromGitHub
, pkg-config
, wrapQtAppsHook
, libnitrokey
, cppcodec
, qttools
}:

stdenv.mkDerivation rec {
  pname = "nitrokey-app";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    rev = "refs/tags/v${version}";
    hash = "sha256-c6EC5uuMna07xVHDRFq0UDwuSeopZTmZGZ9ZD5zaq8Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    qttools
  ];

  cmakeFlags = [
    "-DADD_GIT_INFO=OFF"
    "-DBASH_COMPLETION_PATH=share/bash-completion/completions"
  ];

  buildInputs = [
    libnitrokey
    cppcodec
  ];

  meta = with lib; {
    description = "Provides extra functionality for the Nitrokey Pro and Storage";
    longDescription = ''
      The nitrokey-app provides a QT system tray widget with which you can
      access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
      See https://www.nitrokey.com/ for more information.
    '';
    homepage = "https://github.com/Nitrokey/nitrokey-app";
    changelog = "https://github.com/Nitrokey/nitrokey-app/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kaiha panicgh ];
  };
}
