{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  callPackage,
  withSDL ? true,
  withGLX ? false,
  withDedicated ? true,
}:

let
  d0_blind_id = callPackage ./d0-blind-id.nix { };
  xonotic_darkplaces = callPackage ./xonotic-darkplaces.nix {
    inherit d0_blind_id;
  };

  variant =
    if withSDL && withGLX then
      ""
    else if withSDL then
      "-sdl"
    else if withGLX then
      "-glx"
    else if withDedicated then
      "-dedicated"
    else
      "-what-even-am-i";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xonotic${variant}";
  version = "0.8.6";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "xonotic";
    repo = "xonotic";
    tag = "xonotic-v${finalAttrs.version}";
    hash = "sha256-V4x30GaTRM7GbYtg+oJdPNSrtnxYc3dH/bBcv4ZYkys=";
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals (stdenv.isLinux && (withSDL || withGLX)) [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall

    install -Dm644 misc/logos/xonotic_icon.svg \
      $out/share/icons/hicolor/scalable/apps/xonotic.svg

    pushd misc/logos/icons_png
      for img in *.png; do
        size=''${img#xonotic_}
        size=''${size%.png}
        dimensions="''${size}x''${size}"
        install -Dm644 "$img" \
          "$out/share/icons/hicolor/$dimensions/apps/xonotic.png"
      done
    popd
  ''
  + lib.optionalString withDedicated ''
    install -Dm755 ${xonotic_darkplaces}/bin/darkplaces-dedicated "$out/bin/xonotic-dedicated"
  ''
  + lib.optionalString withGLX ''
    install -Dm755 ${xonotic_darkplaces}/bin/darkplaces-glx "$out/bin/xonotic-glx"
    ln -s xonotic-glx "$out/bin/xonotic"
  ''
  + lib.optionalString withSDL ''
    install -Dm755 ${xonotic_darkplaces}/bin/darkplaces-sdl "$out/bin/xonotic-sdl"
    ln -sf xonotic-sdl "$out/bin/xonotic"
  ''
  + lib.optionalString (stdenv.isDarwin && withSDL) ''
    mkdir -p "$out/Applications/Xonotic.app/Contents/MacOS"
    mkdir -p "$out/Applications/Xonotic.app/Contents/Resources"

    cp misc/buildfiles/osx/Xonotic.app/Contents/Info.plist \
      "$out/Applications/Xonotic.app/Contents/Info.plist"

    cp misc/buildfiles/osx/Xonotic.app/Contents/Resources/Xonotic.icns \
      "$out/Applications/Xonotic.app/Contents/Resources/"

    ln -s "$out/bin/xonotic-sdl" \
      "$out/Applications/Xonotic.app/Contents/MacOS/xonotic-osx-sdl"
  ''
  + ''
    runHook postInstall
  '';

  postFixup =
    let
      bins =
        lib.optional withDedicated "dedicated" ++ lib.optional withGLX "glx" ++ lib.optional withSDL "sdl";
    in
    lib.optionalString (bins != [ ]) ''
      for bin in ${lib.escapeShellArgs bins}; do
        wrapProgram "$out/bin/xonotic-$bin" \
          --add-flags "-basedir ${finalAttrs.passthru.data}"
      done
    '';

  desktopItems = lib.optionals (stdenv.isLinux && (withSDL || withGLX)) [
    (makeDesktopItem {
      name = "xonotic";
      exec = "xonotic";
      comment = finalAttrs.meta.description;
      desktopName = "Xonotic";
      categories = [
        "Game"
        "Shooter"
      ];
      icon = "xonotic";
      startupNotify = false;
    })
  ];

  passthru = {
    xonotic-unwrapped = xonotic_darkplaces;
    data = fetchzip {
      name = "xonotic-data";
      url = "https://dl.xonotic.org/xonotic-${finalAttrs.version}.zip";
      hash = "sha256-Lhjpyk7idmfQAVn4YUb7diGyyKZQBfwNXxk2zMOqiZQ=";
      postFetch = ''
        cd $out

        shopt -s extglob
        rm -rf !(data|key_0.d0pk)
      '';
      meta.hydraPlatforms = [ ];
    };
  };

  meta = {
    description = "Free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, macOS and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = "https://www.xonotic.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zalakain
      philocalyst
    ];
    platforms = lib.platforms.all;
    hydraPlatforms = [ ];
  };
})
