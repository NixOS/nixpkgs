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
  gsl-lite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wesnoth";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "wesnoth";
    repo = "wesnoth";
    tag = finalAttrs.version;
    hash = "sha256-Uk8omtXYZaneyBr4TASRtIKEyJLGwfKWu9vRQNVpdVA=";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # LLVM 19 removed support for types not officially supported by
    # `std::char_traits`:
    # https://libcxx.llvm.org/ReleaseNotes/19.html#deprecations-and-removals
    # Wesnoth relies on this previously supported non-standard behavior for
    # some types that should either have been a vector or span:
    # https://github.com/wesnoth/wesnoth/issues/9546
    # Unfortunately we can't just use `std::span` as that requires C++20,
    # and making Wesnoth C++20 compatible is a non-trivial problem.
    # As a workaround, we make use of gsl-lite, which includes a lightweight
    # implementation of span.
    ./llvm_19-compat.patch
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
  ] ++ lib.optionals stdenv.cc.isClang [ gsl-lite ];

  cmakeFlags = [
    "-DENABLE_SYSTEM_LUA=ON"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app_name="The Battle for Wesnoth"
    app_bundle="$out/Applications/$app_name.app"
    app_contents="$app_bundle/Contents"

    mkdir -p "$app_contents"
    echo "APPL????" > "$app_contents/PkgInfo"

    mv $out/bin "$app_contents/MacOS"
    mv $out/share/wesnoth "$app_contents/Resources"

    pushd ../projectfiles/Xcode

    substitute Info.plist "$app_contents/Info.plist" \
      --replace-fail ''\'''${EXECUTABLE_NAME}' wesnoth \
      --replace-fail '$(PRODUCT_BUNDLE_IDENTIFIER)' org.wesnoth.Wesnoth \
      --replace-fail ''\'''${PRODUCT_NAME}' "$app_name"

    cp -r Resources/SDLMain.nib "$app_contents/Resources/"
    install -m0644 Resources/{container-migration.plist,icon.icns} "$app_contents/Resources"

    popd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      # the minor release number also denotes if this is a beta release:
      # even is stable, odd is beta
      "^(\\d+\\.\\d*[02468]\\.\\d+)$"
    ];
  };

  meta = {
    description = "Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';

    homepage = "https://www.wesnoth.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      abbradar
      niklaskorz
    ];
    platforms = lib.platforms.unix;
  };
})
