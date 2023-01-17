{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, requireFile
, cmake
, pkg-config
, SDL2
, SDL2_image
, audiality2
, useProprietaryAssets ? true
}:

stdenv.mkDerivation rec {
  pname = "koboredux";
  version = "0.7.5.1";

  src =
    [(fetchFromGitHub {
      owner = "olofson";
      repo = "koboredux";
      rev = "v${version}";
      sha256 = "09h9r65z8bar2z89s09j6px0gdq355kjf38rmd85xb2aqwnm6xig";
    })]
    ++
    (lib.optional useProprietaryAssets (requireFile {
      name = "koboredux-${version}-Linux.tar.bz2";
      sha256 = "11bmicx9i11m4c3dp19jsql0zy4rjf5a28x4hd2wl8h3bf8cdgav";
      message = ''
        Please purchase the game on https://olofson.itch.io/kobo-redux
        and download the Linux build.

        Once you have downloaded the file, please use the following command
        and re-run the installation:

        nix-prefetch-url file://\$PWD/koboredux-${version}-Linux.tar.bz2

        Alternatively, install the "koboredux-free" package, which replaces the
        proprietary assets with a placeholder theme.
      '';
    }));

  sourceRoot = "source"; # needed when we have the assets source

  # Fix clang build
  patches = [(fetchpatch {
    url = "https://github.com/olofson/koboredux/commit/cf92b8a61d002ccaa9fbcda7a96dab08a681dee4.patch";
    sha256 = "0dwhvis7ghf3mgzjd2rwn8hk3ndlgfwwcqaq581yc5rwd73v6vw4";
  })];

  postPatch = lib.optionalString useProprietaryAssets ''
    cp -r ../koboredux-${version}-Linux/sfx/redux data/sfx/
    cp -r ../koboredux-${version}-Linux/gfx/redux data/gfx/
    cp -r ../koboredux-${version}-Linux/gfx/redux_fullscreen data/gfx/
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    audiality2
  ];

  meta = with lib; {
    description = "A frantic 80's style 2D shooter, similar to XKobo and Kobo Deluxe" +
      lib.optionalString (!useProprietaryAssets) " (built without proprietary assets)";
    longDescription = ''
      Kobo Redux is a frantic 80's style 2D shooter, inspired by the look and
      feel of 90's arcade cabinets. The gameplay is fast and unforgiving,
      although with less of the frustrating quirkiness of the actual games
      of the 80's. A true challenge in the spirit of the arcade era!
    '' + lib.optionalString (!useProprietaryAssets) ''

      This version replaces the official proprietary assets with placeholders.
      For the full experience, consider installing "koboredux" instead.
    '';
    homepage = "https://olofson.itch.io/kobo-redux";
    license = with licenses; if useProprietaryAssets then unfree else gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}

