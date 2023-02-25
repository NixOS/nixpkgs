{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, curl
, libevent
, libsearpc
, libuuid
, libwebsockets
, pkg-config
, python3
, sqlite
, vala
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "8.0.10";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    # Upstream has a habit of retagging, tracking revision instead
    rev = "91e5d897395c728a1e862dbdaf3d8a519c2ed73e";
    sha256 = "sha256-mHpH9Xr4t0wP0yKo3Zc8RzjKKipJ6kgxAZbtg6pq7vE=";
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
    libwebsockets
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
