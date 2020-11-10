{stdenv, fetchFromGitHub, cmake, libGLU, libGL, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0.2019.10.18"; in
stdenv.mkDerivation {
  pname = "openxcom";
  inherit version;
  src = fetchFromGitHub {
    owner = "OpenXcom";
    repo = "OpenXcom";
    rev = "f9853b2cb8c8f741ac58707487ef493416d890a3";
    sha256 = "0kbfawj5wsp1mwfcm5mwpkq6s3d13pailjm5w268gqpxjksziyq0";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGLU libGL openssl zlib ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = "https://openxcom.org";
    repositories.git = "https://github.com/SupSuper/OpenXcom.git";
    maintainers = [ stdenv.lib.maintainers.cpages ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };

}
