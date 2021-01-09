{ stdenv
, fetchFromGitHub
, autoreconfHook
, ccnet
, curl
, fuse
, glib
, intltool
, libevent
, libsearpc
, libuuid
, pkg-config
, python3
, sqlite
, vala
, which
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "d34499a2aafa024623a4210fe7f663cef13fe9a6";
    sha256 = "VKoGr3CTDFg3Q0X+MTlwa4BbfLB+28FeTyTJRCq37RA=";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
