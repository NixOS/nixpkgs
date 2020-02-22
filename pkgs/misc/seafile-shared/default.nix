{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, vala, python2, curl, libevent, glib, libsearpc, sqlite, intltool, fuse, ccnet, libuuid }:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "7.0.5";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "162dnm3sf7bkrnyqd8bcb6il6f2cam9gnaxj6d5dn48k77fw9ryc";
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
