{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
  libevent,
  libsearpc,
  libuuid,
  pkg-config,
  python3,
  sqlite,
  vala,
  libwebsockets,
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "9.0.5";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "sha256-ENxmRnnQVwRm/3OXouM5Oj0fLVRSj0aOHJeVT627UdY=";
  };

  nativeBuildInputs = [
    libwebsockets
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
    maintainers = with maintainers; [
      greizgh
      schmittlauch
    ];
  };
}
