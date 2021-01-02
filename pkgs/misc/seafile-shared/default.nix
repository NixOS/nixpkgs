{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, vala, python2, curl, libevent, glib, libsearpc, sqlite, intltool, fuse, libuuid }:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "7.0.10";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "0b3297cbagi9x8dnw2gjifmb8dk6vyhg6vfrfsanm1wyx8pgw2jg";
  };

  nativeBuildInputs = [
    autoreconfHook
    vala
    pkgconfig
    python2
    python2.pkgs.wrapPython
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
  ];

  pythonPath = with python2.pkgs; [
    future
    libsearpc
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
