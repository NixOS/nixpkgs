{ stdenv, fetchFromGitHub, fetchsvn, pkgconfig, scons, mesa, SDL2, SDL2_image, libvorbis,
  bullet, curl, gettext }:

stdenv.mkDerivation rec {
  version = "2014-10-20";
  name = "vdrift-${version}";

  src = fetchFromGitHub {
    owner = "VDrift";
    repo = "vdrift";
    rev = version;
    sha256 = "09yny5qzdrpffq3xhqwfymsracwsxwmdd5xa8bxx9a56hhxbak2l";
  };

  data = fetchsvn {
    url = "svn://svn.code.sf.net/p/vdrift/code/vdrift-data";
    rev = 1386;
    sha256 = "0ka6zir9hg0md5p03dl461jkvbk05ywyw233hnc3ka6shz3vazi1";
  };

  buildInputs = [ pkgconfig scons mesa SDL2 SDL2_image libvorbis bullet curl gettext ];

  buildPhase = ''
    cp -r --reflink=auto $data data
    chmod -R +w data
    sed -i -e s,/usr/local,$out, SConstruct
    scons
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
