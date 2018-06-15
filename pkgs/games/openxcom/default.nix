{stdenv, fetchFromGitHub, fetchpatch, cmake, libGLU_combined, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0.2018.01.28"; in
stdenv.mkDerivation {
  name = "openxcom-${version}";
  src = fetchFromGitHub {
    owner = "SupSuper";
    repo = "OpenXcom";
    rev = "b148916268a6ce104c3b6b7eb4d9e0487cba5487";
    sha256 = "1128ip3g4aw59f3f23mvlyhl8xckhwjjw9rd7wn7xv51hxdh191c";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGLU_combined openssl zlib ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = http://openxcom.org;
    repositories.git = https://github.com/SupSuper/OpenXcom.git;
    maintainers = [ stdenv.lib.maintainers.cpages ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };

}
