{ stdenv, autoreconfHook, fetchFromGitHub, pkgconfig
, lua, fpc, pcre, portaudio, freetype, libpng
, SDL2, SDL2_image, SDL2_gfx, SDL2_mixer, SDL2_net, SDL2_ttf
, ffmpeg, sqlite, zlib, libX11, libGLU_combined }:

let
  sharedLibs = [
    pcre portaudio freetype
    SDL2 SDL2_image SDL2_gfx SDL2_mixer SDL2_net SDL2_ttf
    sqlite lua zlib libX11 libGLU_combined ffmpeg
  ];

in stdenv.mkDerivation rec {
  name = "ultrastardx-${version}";
  version = "2017.8.0";
  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${version}";
    sha256 = "1zp0xfwzci3cjmwx3cprcxvm60cik5cvhvrz9n4d6yb8dv38nqzm";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ fpc libpng ] ++ sharedLibs;

  postPatch = ''
    # autoconf substitutes strange things otherwise
    substituteInPlace src/config.inc.in \
      --subst-var-by libpcre_LIBNAME libpcre.so.1
  '';

  preBuild = with stdenv.lib;
    let items = concatMapStringsSep " " (x: "-rpath ${getLib x}/lib") sharedLibs;
    in ''
      export NIX_LDFLAGS="$NIX_LDFLAGS ${items}"
    '';

  # dlopened libgcc requires the rpath not to be shrinked
  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = http://ultrastardx.sourceforge.net/;
    description = "Free and open source karaoke game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Profpatsch ];
  };
}
