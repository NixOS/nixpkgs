{ stdenv, fetchFromGitHub, fetchsvn, pkgconfig, scons, mesa, SDL2, SDL2_image, libvorbis,
  bullet, curl, gettext }:

stdenv.mkDerivation rec {
  version = "git";
  name = "vdrift-${version}";

  src = fetchFromGitHub {
    owner = "vdrift";
    repo = "vdrift";
    rev = "12d444ed18395be8827a21b96cc7974252fce6d1";
    sha256 = "001wq3c4n9wzxqfpq40b1jcl16sxbqv2zbkpy9rq2wf9h417q6hg";
  };

  data = fetchsvn {
    url = "svn://svn.code.sf.net/p/vdrift/code/vdrift-data";
    rev = 1386;
    sha256 = "0ka6zir9hg0md5p03dl461jkvbk05ywyw233hnc3ka6shz3vazi1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ scons mesa SDL2 SDL2_image libvorbis bullet curl gettext ];

  buildPhase = ''
    cp -r --reflink=auto $data data
    chmod -R +w data
    sed -i -e s,/usr/local,$out, SConstruct
    export CXXFLAGS="$(pkg-config --cflags SDL2_image)"
    scons -j$NIX_BUILD_CORES
  '';
  installPhase = "scons install";

  meta = {
    description = "Car racing game";
    homepage = http://vdrift.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
