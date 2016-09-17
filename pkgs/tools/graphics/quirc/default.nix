{stdenv, fetchgit, SDL_gfx, SDL, libjpeg, libpng, pkgconfig}:
let
  s =
  rec {
    date = "2016-08-16";
    version = "git-${date}";
    baseName = "quirc";
    name = "${baseName}-${version}";
    url = "https://github.com/dlbeer/quirc";
    rev = "5b262480091d5f84a67a4a56c728fc8b39844339";
    sha256 = "1w5qvjafn14s6jjs7kiwsqirlsqbgv0p152hrsq463pm34hp0lzy";
  };
  buildInputs = [
    SDL SDL_gfx libjpeg pkgconfig libpng
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    inherit (s) url sha256 rev;
  };
  NIX_CFLAGS_COMPILE="-I${SDL.dev}/include/SDL -I${SDL_gfx}/include/SDL";
  configurePhase = ''
    sed -e 's/-[og] root//g' -i Makefile
  '';
  preInstall = ''
    mkdir -p "$out"/{bin,lib,include}
    find . -maxdepth 1 -type f -perm -0100 -exec cp '{}' "$out"/bin ';'
  '';
  makeFlags = "PREFIX=$(out)";
  meta = {
    inherit (s) version;
    description = ''A small QR code decoding library'';
    license = stdenv.lib.licenses.isc;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
