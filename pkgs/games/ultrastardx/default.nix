{ lib, stdenv
, autoreconfHook
, fetchFromGitHub
, fetchpatch
, pkg-config
, lua
, fpc
, pcre
, portaudio
, freetype
, libpng
, SDL2
, SDL2_image
, SDL2_gfx
, SDL2_mixer
, SDL2_net, SDL2_ttf
, ffmpeg_4
, sqlite
, zlib
, libX11
, libGLU
, libGL
}:

let
  sharedLibs = [
    pcre portaudio freetype
    SDL2 SDL2_image SDL2_gfx SDL2_mixer SDL2_net SDL2_ttf
    sqlite lua zlib libX11 libGLU libGL ffmpeg_4
  ];

in stdenv.mkDerivation rec {
  pname = "ultrastardx";
  version = "2021-04-03";
  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "d49e916705092f3d765d85d276b283b9e7e232a6";
    sha256 = "0sdcz2vc8i2z50nj7zbkdpxx2mvx0m0927lfsj7d7qr0p8vkm0wa";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ fpc libpng ] ++ sharedLibs;

  postPatch = ''
    substituteInPlace src/config.inc.in \
      --subst-var-by libpcre_LIBNAME libpcre.so.1

    # ultrastardx binds to libffmpeg (and sublibs), specifying a very restrictive
    # upper bounds on the minor versions of .so files.
    # We can assume ffmpeg_4 won’t break any major ABI compatibility, since it's
    # effectively EOL
    sed \
      -e 's/^  LIBAVCODEC_MAX_VERSION_MINOR.*$/  LIBAVCODEC_MAX_VERSION_MINOR = 1000;/' \
      -i src/lib/ffmpeg-4.0/avcodec.pas
    sed \
      -e 's/^  LIBAVFORMAT_MAX_VERSION_MINOR.*$/  LIBAVFORMAT_MAX_VERSION_MINOR = 1000;/' \
      -i src/lib/ffmpeg-4.0/avformat.pas
    sed \
      -e 's/^  LIBAVUTIL_MAX_VERSION_MINOR.*$/  LIBAVUTIL_MAX_VERSION_MINOR = 1000;/' \
      -i src/lib/ffmpeg-4.0/avutil.pas
    sed \
      -e 's/^  LIBSWRESAMPLE_MAX_VERSION_MINOR.*$/  LIBSWRESAMPLE_MAX_VERSION_MINOR = 1000;/' \
      -i src/lib/ffmpeg-4.0/swresample.pas
    sed \
      -e 's/^  LIBSWSCALE_MAX_VERSION_MINOR.*$/  LIBSWSCALE_MAX_VERSION_MINOR = 1000;/' \
      -i src/lib/ffmpeg-4.0/swscale.pas
  '';

  preBuild = with lib;
    let items = concatMapStringsSep " " (x: "-rpath ${getLib x}/lib") sharedLibs;
    in ''
      export NIX_LDFLAGS="$NIX_LDFLAGS ${items}"
    '';

  # dlopened libgcc requires the rpath not to be shrinked
  dontPatchELF = true;

  meta = with lib; {
    homepage = "http://ultrastardx.sourceforge.net/";
    description = "Free and open source karaoke game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Profpatsch ];
  };
}
