{stdenv, fetchFromGitHub, cmake, libGLU_combined, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0.2018.10.08"; in
stdenv.mkDerivation {
  pname = "openxcom";
  inherit version;
  src = fetchFromGitHub {
    owner = "SupSuper";
    repo = "OpenXcom";
    rev = "13049d617fe762b91893faaf7c14ddefa49e2f1d";
    sha256 = "0vpcfk3g1bnwwmrln14jkj2wvw2z8igxw2mdb7c3y66466wm93ig";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL SDL_gfx SDL_image SDL_mixer boost libyamlcpp libGLU_combined openssl zlib ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = https://openxcom.org;
    repositories.git = https://github.com/SupSuper/OpenXcom.git;
    maintainers = [ stdenv.lib.maintainers.cpages ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };

}
