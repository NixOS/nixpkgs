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
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "2493113afb174b1a0e6f860512922b69c05cee69";
    sha256 = "1lz3rx5wy6clw3wnnb417jkhgb06min6p42f78917q2pfpprg59q";
  };

  nativeBuildInputs = [
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
    maintainers = with maintainers; [ greizgh ];
  };
}
