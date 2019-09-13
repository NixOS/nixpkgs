{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, curl, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec {
  version = "7.0.2";
  pname = "seafile-shared";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "0633hhz2cky95y8mvrg9q2cyrnzpnzvn8fcq350wl4a64ij6wa04";
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
