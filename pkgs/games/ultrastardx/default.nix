{ lib, stdenv
, autoreconfHook
, fetchFromGitHub
, fetchpatch
, pkgconfig
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
, ffmpeg
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
    sqlite lua zlib libX11 libGLU libGL ffmpeg
  ];

in stdenv.mkDerivation rec {
  pname = "ultrastardx";
  version = "2020.4.0";
  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${version}";
    sha256 = "0vmfv8zpyf8ymx3rjydpd7iqis080lni94vb316vfxkgvjmqbhym";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ fpc libpng ] ++ sharedLibs;

  patches = [
    (fetchpatch {
      name = "fpc-3.2-support.patch";
      url = "https://github.com/UltraStar-Deluxe/USDX/commit/1b8e8714c1523ef49c2fd689a1545d097a3d76d7.patch";
      sha256 = "02zmjymj9w1mkpf7armdpf067byvml6lprs1ca4lhpkv45abddp4";
    })
  ];

  postPatch = ''
    substituteInPlace src/config.inc.in \
      --subst-var-by libpcre_LIBNAME libpcre.so.1
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
