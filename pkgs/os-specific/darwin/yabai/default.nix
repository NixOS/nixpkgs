{ lib
, stdenv
, stdenvNoCC
, fetchFromGitHub
, fetchzip
, writeShellScript
, installShellFiles
, testers
, yabai
, xxd
, xcodebuild
  # These all need to be from SDK 11.0 or later starting with yabai 5.0.0
, Carbon
, Cocoa
, ScriptingBridge
, SkyLight
}:

let
  pname = "yabai";
  version = "5.0.2";

  test-version = testers.testVersion {
    package = yabai;
    version = "yabai-v${version}";
  };

  _meta = with lib; {
    description = "A tiling window manager for macOS based on binary space partitioning";
    longDescription = ''
      yabai is a window management utility that is designed to work as an extension to the built-in
      window manager of macOS. yabai allows you to control your windows, spaces and displays freely
      using an intuitive command line interface and optionally set user-defined keyboard shortcuts
      using skhd and other third-party software.
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    changelog = "https://github.com/koekeishiya/yabai/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [
      cmacrae
      shardy
      ivar
    ];
  };
in
{
  # Unfortunately compiling yabai from source on aarch64-darwin is a bit complicated. We use the precompiled binary instead for now.
  # See the comments on https://github.com/NixOS/nixpkgs/pull/188322 for more information.
  aarch64-darwin = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "sha256-wL6N2+mfFISrOFn4zaCQI+oH6ixwUMRKRi1dAOigBro=";
    };

    nativeBuildInputs = [
      installShellFiles
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./bin $out
      installManPage ./doc/yabai.1

      runHook postInstall
    '';

    passthru.tests.version = test-version;

    meta = _meta // {
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
      ];
    };
  };

  x86_64-darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v${version}";
      sha256 = "sha256-/HS8TDzDA4Zvmm56ZZeMXyCKHRRTcucd7qDHT0qbrQg=";
    };

    nativeBuildInputs = [
      installShellFiles
      xcodebuild
      xxd
    ];

    buildInputs = [
      Carbon
      Cocoa
      ScriptingBridge
      SkyLight
    ];

    dontConfigure = true;
    enableParallelBuilding = true;

    postPatch = ''
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

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

      cp ./bin/yabai $out/bin/yabai
      cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
      installManPage ./doc/yabai.1

      runHook postInstall
    '';

    passthru.tests.version = test-version;

    meta = _meta // {
      sourceProvenance = with lib.sourceTypes; [
        fromSource
      ];
    };
  };
}.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}")
