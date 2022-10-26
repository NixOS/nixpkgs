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
, Carbon
, Cocoa
, ScriptingBridge
  # This needs to be from SDK 10.13 or higher, SLS APIs introduced in that version get used
, SkyLight
}:

let
  pname = "yabai";
  version = "4.0.4";

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
      sha256 = "sha256-NS8tMUgovhWqc6WdkNI4wKee411i/e/OE++JVc86kFE=";
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

  x86_64-darwin = stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v${version}";
      sha256 = "sha256-TeT+8UAV2jR60XvTs4phkp611Gi0nzLmQnezLA0xb44=";
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
      ln -s ${loadScriptingAddition} $out/bin/yabai-load-sa
      cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
      installManPage ./doc/yabai.1

      runHook postInstall
    '';

    # Defining this here exposes it as a passthru attribute, which is useful because it allows us to run `builtins.hashFile` on it in pure-eval mode.
    # With that we can programatically generate an `/etc/sudoers.d` entry which disables the password requirement, so that a user-agent can run it at login.
    loadScriptingAddition = writeShellScript "yabai-load-sa" ''
      # For whatever reason the regular commands to load the scripting addition do not work, yabai will throw an error.
      # The installation command mutably installs binaries to '/System', but then fails to start them. Manually running
      # the bins as root does start the scripting addition, so this serves as a more user-friendly way to do that.

      set -euo pipefail

      if [[ "$EUID" != 0 ]]; then
          echo "error: the scripting-addition loader must ran as root. try 'sudo $0'"
          exit 1
      fi

      loaderPath="/Library/ScriptingAdditions/yabai.osax/Contents/MacOS/mach_loader";

      if ! test -x "$loaderPath"; then
          echo "could not locate the scripting-addition loader at '$loaderPath', installing it..."
          echo "note: this may display an error"

          eval "$(dirname "''${BASH_SOURCE[0]}")/yabai --install-sa" || true
          sleep 1
      fi

      echo "executing loader..."
      eval "$loaderPath"
      echo "scripting-addition started"
    '';

    passthru.tests.version = test-version;

    meta = _meta // {
      longDescription = _meta.longDescription + ''
        Note that due to a nix-only bug the scripting addition cannot be launched using the regular
        procedure. Instead, you can use the provided `yabai-load-sa` script.
      '';

      sourceProvenance = with lib.sourceTypes; [
        fromSource
      ];
    };
  };
}.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}")
