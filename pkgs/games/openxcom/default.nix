{stdenv, fetchurl, fetchpatch, cmake, mesa, zlib, openssl, libyamlcpp, boost
, SDL, SDL_image, SDL_mixer, SDL_gfx }:

let version = "1.0.0"; in
stdenv.mkDerivation {
  name = "openxcom-${version}";
  src = fetchurl {
    url = http://openxcom.org/file/1726/;
    sha256 = "1rmg10nklvf86ckbbssyvbg5cd4p7in5zq3mas2yyffdjk9i40v6";
    name = "openxcom-${version}.tar.gz";
  };

  buildInputs = [ cmake mesa zlib openssl libyamlcpp boost
    SDL SDL_image SDL_mixer SDL_gfx ];

  patches = [ (fetchpatch {
    url = "https://github.com/SupSuper/OpenXcom/commit/49bec0851fc6e5365cac0f71b2c40a80ddf95e77.patch";
    sha256 = "156fk8wz4qc0nmqq3zjb6kw84qirabads2azr6xvlgb3lcn327v2";
  }) ];

  meta = {
    description = "Open source clone of UFO: Enemy Unknown";
    homepage = http://openxcom.org;
    repositories.git = https://github.com/SupSuper/OpenXcom.git;
    maintainers = [ stdenv.lib.maintainers.cpages ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };

}
