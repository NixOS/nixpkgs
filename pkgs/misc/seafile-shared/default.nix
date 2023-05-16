{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, curl
, libevent
, libsearpc
, libuuid
, pkg-config
, python3
, sqlite
, vala
<<<<<<< HEAD
, libwebsockets
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
<<<<<<< HEAD
  version = "9.0.3";
=======
  version = "8.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
<<<<<<< HEAD
    rev = "v${version}";
    sha256 = "sha256-g8MQFhDBBUuEDGsJ14rHGsaGEznOtCMVOv+5kljXByY=";
  };

  nativeBuildInputs = [
    libwebsockets
=======
    rev = "0fdc14d5175979919b7c741f6bb97bfaaacbbfbe";
    sha256 = "1cr1hvpp96s5arnzh1r5sazapcghhvbazbf7zym37yp3fy3lpya1";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    autoreconfHook
    vala
    pkg-config
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    libuuid
    sqlite
    libsearpc
    libevent
    curl
  ];

  configureFlags = [
    "--disable-server"
    "--with-python3"
  ];

  pythonPath = with python3.pkgs; [
    future
    pysearpc
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
