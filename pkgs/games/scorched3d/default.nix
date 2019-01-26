{ stdenv, fetchurl, libGLU_combined, glew, pkgconfig, openalSoft, freealut, wxGTK, libogg
, freetype, libvorbis, fftwSinglePrec, SDL, SDL_net, expat, libjpeg, libpng }:

stdenv.mkDerivation rec {
  version = "44";
  name = "scorched3d-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/scorched3d/Scorched3D-${version}-src.tar.gz";
    sha256 = "1fldi9pn7cz6hc9h70pacgb7sbykzcac44yp3pkhn0qh4axj10qw";
  };

  buildInputs =
    [ libGLU_combined glew openalSoft freealut wxGTK libogg freetype libvorbis
      SDL SDL_net expat libjpeg libpng fftwSinglePrec
    ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [
    ./file-existence.patch
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/games-strategy/scorched3d/files/scorched3d-44-fix-c++14.patch?id=1bbcfc9ae3dfdfcbdd35151cb7b6050776215e4d";
      sha256 = "1farmjxbc2wm4scsdbdnvh29fipnb6mp6z85hxz4bx6n9kbc8y7n";
    })
  ];

  sourceRoot = "scorched";

  configureFlags = [ "--with-fftw=${fftwSinglePrec.dev}" ];

  NIX_LDFLAGS = [ "-lopenal" ];

  meta = with stdenv.lib; {
    homepage = http://scorched3d.co.uk/;
    description = "3D Clone of the classic Scorched Earth";
    license = licenses.gpl2Plus;
    platforms = platforms.linux; # maybe more
    maintainers = with maintainers; [ abbradar ];
  };
}
