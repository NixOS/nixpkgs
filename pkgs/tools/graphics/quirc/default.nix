{stdenv, fetchgit, SDL_gfx, SDL, libjpeg, pkgconfig}:
let
  s =
  rec {
    date = "2014-11-01";
    version = "git-${date}";
    baseName = "quirc";
    name = "${baseName}-${version}";
    url = "https://github.com/dlbeer/quirc";
    rev = "3a3df0d1d6adc59fdc2cadecfaed91650b84cacb";
    sha256 = "0wk2lmnw1k6m12dxs5a684mrm05x362h5kr3dwkfj8pyvdw3am18";
  };
  buildInputs = [
    SDL SDL_gfx libjpeg pkgconfig
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchgit {
    inherit (s) url sha256 rev;
  };
  NIX_CFLAGS_COMPILE="-I${SDL.dev}/include/SDL";
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
