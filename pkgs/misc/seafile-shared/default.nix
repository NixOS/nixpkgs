{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, curl, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec {
  version = "7.0.1";
  name = "seafile-shared-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "0d53r3s6ylr4zlbsrxi8z0z7s2lzh05wbqhfxz4n1vva6izz11bk";
  };

  nativeBuildInputs = [ pkgconfig which autoreconfHook vala intltool ];
  buildInputs = [ python fuse ];
  propagatedBuildInputs = [ ccnet curl ];

  configureFlags = [
    "--disable-server"
    "--disable-console"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile;
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
