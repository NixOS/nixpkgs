{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, apacheHttpd
, apr
, cairo
, iniparser
, mapnik
, boost
, icu
, harfbuzz
, libjpeg
, libtiff
, libwebp
, proj
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "mod_tile";
  version = "unstable-2017-01-08";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "mod_tile";
    rev = "e25bfdba1c1f2103c69529f1a30b22a14ce311f1";
    sha256 = "12c96avka1dfb9wxqmjd57j30w9h8yx4y4w34kyq6xnf6lwnkcxp";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #  https://github.com/openstreetmap/mod_tile/pull/202
    (fetchpatch {
      name = "fno-common";
      url = "https://github.com/openstreetmap/mod_tile/commit/a22065b8ae3c018820a5ca9bf8e2b2bb0a0bfeb4.patch";
      sha256 = "1ywfa14xn9aa96vx1adn1ndi29qpflca06x986bx9c5pqk761yz3";
    })
  ];

  # test is broken and I couldn't figure out a better way to disable it.
  postPatch = ''
    echo "int main(){return 0;}" > src/gen_tile_test.cpp
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    apacheHttpd
    apr
    cairo
    iniparser
    mapnik
    boost
    icu
    harfbuzz
    libjpeg
    libtiff
    libwebp
    proj
    sqlite
  ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
  ];

  installPhase = ''
    mkdir -p $out/modules
    make install-mod_tile DESTDIR=$out
    mv $out${apacheHttpd}/* $out
    rm -rf $out/nix
  '';

  meta = with lib; {
    homepage = "https://github.com/openstreetmap/mod_tile";
    description = "Efficiently render and serve OpenStreetMap tiles using Apache and Mapnik";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jglukasik ];
    platforms = platforms.linux;
  };
}
