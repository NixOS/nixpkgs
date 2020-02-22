{stdenv, fetchFromGitHub, scons, zlib, SDL, lua5_1, pkgconfig}:

stdenv.mkDerivation {
  pname = "fceux-unstable";
  version = "2020-01-29";

  src = fetchFromGitHub {
    owner = "TASVideos";
    repo = "fceux";
    rev = "fb8d46d9697cb24b0ebe79d84eedf282f69ab337";
    sha256 = "0gpz411dzfwx9mr34yi4zb1hphd5hha1nvwgzxki0sviwafca992";
  };

  nativeBuildInputs = [ pkgconfig scons ];
  buildInputs = [
    zlib SDL lua5_1
  ];

  sconsFlags = "OPENGL=false GTK=false CREATE_AVI=false LOGO=false";
  prefixKey = "--prefix=";

  # sed allows scons to find libraries in nix.
  # mkdir is a hack to make scons succeed.  It still doesn't
  # actually put the files in there due to a bug in the SConstruct file.
  # OPENGL doesn't work because fceux dlopens the library.
  preBuild = ''
    sed -e 's/env *= *Environment *.*/&; env['"'"'ENV'"'"']=os.environ;/' -i SConstruct
    export CC="gcc"
    export CXX="g++"
    mkdir -p "$out" "$out/share/applications" "$out/share/pixmaps"
  '';

  meta = {
    description = "A Nintendo Entertainment System (NES) Emulator";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.scubed2 ];
    homepage = http://www.fceux.com/;
    platforms = stdenv.lib.platforms.linux;
  };
}
