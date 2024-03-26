{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, installShellFiles
, testers
, yabai
, xxd
, xcodebuild
, Carbon
, Cocoa
, ScriptingBridge
, SkyLight
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yabai";
  version = "7.0.2";

  src =
    # Unfortunately compiling yabai from source on aarch64-darwin is a bit complicated. We use the precompiled binary instead for now.
    # See the comments on https://github.com/NixOS/nixpkgs/pull/188322 for more information.
    if stdenv.isAarch64 then
      (fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${finalAttrs.version}/yabai-v${finalAttrs.version}.tar.gz";
        hash = "sha256-FeNiJJM5vdzFT9s7N9cTjLYxKEfzZnKE9br13lkQhJo=";
      })
    else if stdenv.isx86_64 then
      (fetchFromGitHub {
        owner = "koekeishiya";
        repo = "yabai";
        rev = "v${finalAttrs.version}";
        hash = "sha256-/MOAKsY7MlRWdvUQwHeITTeGJbCUdX7blZZAl2zXuic=";
      })
    else (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  env = {
    # silence service.h error
    NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";
  };

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.isx86_64 [
    xcodebuild
    xxd
  ];

  buildInputs = [ ] ++ lib.optionals stdenv.isx86_64 [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

  dontConfigure = true;
  dontBuild = stdenv.isAarch64;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    cp ./bin/yabai $out/bin/yabai
    ${lib.optionalString stdenv.isx86_64 "cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg"}
    installManPage ./doc/yabai.1

    runHook postInstall
  '';

  postPatch = lib.optionalString stdenv.isx86_64 /* bash */ ''
    # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
    # Since multilib doesnt work on darwin i dont know of a better way of handling this.
    substituteInPlace makefile \
    --replace "-arch arm64e" "" \
    --replace "-arch arm64" "" \
    --replace "clang" "${stdenv.cc.targetPrefix}clang"

    # `NSScreen::safeAreaInsets` is only available on macOS 12.0 and above, which frameworks arent packaged.
    # When a lower OS version is detected upstream just returns 0, so we can hardcode that at compiletime.
    # https://github.com/koekeishiya/yabai/blob/v4.0.2/src/workspace.m#L109
    substituteInPlace src/workspace.m \
    --replace 'return screen.safeAreaInsets.top;' 'return 0;'
  '';

  passthru.tests.version = testers.testVersion {
    package = yabai;
    version = "yabai-v${finalAttrs.version}";
  };

  meta = {
    description = "A tiling window manager for macOS based on binary space partitioning";
    longDescription = ''
      yabai is a window management utility that is designed to work as an extension to the built-in
      window manager of macOS. yabai allows you to control your windows, spaces and displays freely
      using an intuitive command line interface and optionally set user-defined keyboard shortcuts
      using skhd and other third-party software.
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    changelog = "https://github.com/koekeishiya/yabai/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "yabai";
    maintainers = with lib.maintainers; [
      cmacrae
      shardy
      ivar
      khaneliman
    ];
    sourceProvenance = with lib.sourceTypes; [ ]
      ++ lib.optionals stdenv.isx86_64 [
      fromSource
    ] ++ lib.optionals stdenv.isAarch64 [
      binaryNativeCode
    ];
  };
})

