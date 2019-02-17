{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, curl, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec {
  version = "6.2.11";
  name = "seafile-shared-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "16d4m5n5zhip13l6pv951lm081pnwxpiqcm7j4gxqm1ian48m787";
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
