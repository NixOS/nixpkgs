{stdenv, fetchFromGitHub, libzip, autoconf, automake, libtool, m4}:
stdenv.mkDerivation rec {
  baseName = "runzip";
  version = "1.4";
  name = "${baseName}-${version}";
  buildInputs = [libzip autoconf automake libtool m4];
  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };
  preConfigure = ''
    autoreconf -iv
  '';
  meta = {
    inherit version;
    description = ''A tool to convert filename encoding inside a ZIP archive'';
    license = stdenv.lib.licenses.bsd2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
