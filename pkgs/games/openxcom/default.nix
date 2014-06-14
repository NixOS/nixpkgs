{stdenv, fetchurl, cmake, mesa, zlib, openssl, libyamlcpp, boostHeaders
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0"; in
stdenv.mkDerivation {
  name = "openxcom-${version}";
  src = fetchurl {
    url = http://openxcom.org/wp-content/plugins/download-monitor/download.php?id=31;
    sha256 = "00pc6ncsjbvn6w8whpj0bk4hlh577wh40bkyv6lk0g5c901p732l";
    name = "openxcom-${version}.tar.gz";
  };

  buildInputs = [ cmake mesa zlib openssl libyamlcpp boostHeaders
    SDL SDL_image SDL_mixer SDL_gfx ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = http://openxcom.org;
    repositories.git = https://github.com/SupSuper/OpenXcom.git;
    maintainers = [ stdenv.lib.maintainers.page ];
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv3";
  };

}
