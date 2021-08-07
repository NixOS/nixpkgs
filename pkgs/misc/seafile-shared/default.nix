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
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "QflLh3fj+jOq/8etr9aG8LGrvtIlB/htVkWbdO+GIbM=";
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
    "--disable-console"
    "--with-python3"
  ];

  pythonPath = with python3.pkgs; [
    libsearpc
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
