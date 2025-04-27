{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  pango,
  gettext,
  boost,
  libvorbis,
  fribidi,
  dbus,
  libpng,
  pcre,
  openssl,
  icu,
  lua,
  curl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "wesnoth";
  version = "1.18.4";

  src = fetchFromGitHub {
    rev = version;
    owner = "wesnoth";
    repo = "wesnoth";
    hash = "sha256-c3BoTFnSUqtp71QeSCsC2teVuzsQwV8hOJtIcZdP+1E=";
  };

  # LLVM 19 removed support for types not officially supported by `std::char_traits`:
  # https://libcxx.llvm.org/ReleaseNotes/19.html#deprecations-and-removals
  # Wesnoth <1.19 relies on this previously supported non-standard behavior for
  # some types that should either have been a vector or span:
  # https://github.com/wesnoth/wesnoth/issues/9546
  # Wesnoth moved to a `std::span` wrapper for byte views in the 1.19 branch, which we apply as
  # patches until 1.20 is released.
  patches = lib.optionals (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "19") [
    # The next two patches are cherry-picked from https://github.com/wesnoth/wesnoth/pull/10102,
    # which is already included in the 1.19 branch.
    # Introduces the `std::span` wrapper based on `boost::span`.
    (fetchpatch {
      url = "https://github.com/wesnoth/wesnoth/commit/63266cc2c88fefa7e0792ac59d14c14e3711440c.patch";
      hash = "sha256-3Zi/njG7Kovmyd7yiKUoeu4u0QPQxxw+uLz+k9isOLU=";
    })
    # Replace all string views with spans.
    (fetchpatch {
      url = "https://github.com/wesnoth/wesnoth/commit/d3daa161eb2c02670b5ffbcf86cd0ec787f6b9ee.patch";
      hash = "sha256-9DCeZQZKE6fN91T5DCpNJsKGXbv5ihZC8UpuNkiA9zc=";
    })
    # Wesnoth <1.19 uses `std::basic_string` for lightmap computations, which is not standard compliant
    # and incompatible to LLVM 19.
    # While this was fixed in https://github.com/wesnoth/wesnoth/pull/10128, the fix is not
    # trivially backportable to 1.18 so we apply a simpler fix instead.
    ./llvm19-lightmap.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    pango
    gettext
    boost
    libvorbis
    fribidi
    dbus
    libpng
    pcre
    openssl
    icu
    lua
    curl
  ];

  cmakeFlags = [
    "-DENABLE_SYSTEM_LUA=ON"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  meta = with lib; {
    description = "Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = "https://www.wesnoth.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
