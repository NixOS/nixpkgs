{
  runCommand,
  makeWrapper,
  fontconfig_file,
  chromium,
  fetchzip,
  revision,
  suffix,
  system,
  throwSystem,
  lib,
  alsa-lib,
  at-spi2-atk,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gobject-introspection,
  libGL,
  libgbm,
  libgcc,
  libxkbcommon,
  nspr,
  nss,
  pango,
  patchelf,
  pciutils,
  stdenv,
  systemd,
  vulkan-loader,
  xorg,
  ...
}:
let
  chromium-linux = stdenv.mkDerivation {
    name = "playwright-chromium";
    src = fetchzip {
      url = "https://playwright.azureedge.net/builds/chromium/${revision}/chromium-${suffix}.zip";
      hash =
        {
          x86_64-linux = "sha256-R7nMCVpUqgRwtB0syhfIK81maiTVWr8lYBLp4bR8VBg=";
          aarch64-linux = "sha256-4fc4X7QwBigktmEeseuqIyEeV70Dy3eO/femXrftMd0=";
        }
        .${system} or throwSystem;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      patchelf
      makeWrapper
    ];
    buildInputs = [
      alsa-lib
      at-spi2-atk
      atk
      cairo
      cups
      dbus
      expat
      glib
      gobject-introspection
      libgbm
      libgcc
      libxkbcommon
      nspr
      nss
      pango
      stdenv.cc.cc.lib
      systemd
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/chrome-linux
      cp -R . $out/chrome-linux

      wrapProgram $out/chrome-linux/chrome \
        --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
        --set-default FONTCONFIG_FILE ${fontconfig_file}

      runHook postInstall
    '';

    appendRunpaths = lib.makeLibraryPath [
      libGL
      vulkan-loader
      pciutils
    ];

    postFixup = ''
      # replace bundled vulkan-loader since we are also already adding our own to RPATH
      rm "$out/chrome-linux/libvulkan.so.1"
      ln -s -t "$out/chrome-linux" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    '';
  };
  chromium-darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/chromium/${revision}/chromium-${suffix}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-0u1AStbUTX+qgUmg2DvL59B4b265WywDaBV+MdSuaNE=";
        aarch64-darwin = "sha256-4pg4wmNTF8mw+APmdpvYlFxb9zc6OUh11oW5gCRKETY=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = chromium-linux;
  aarch64-linux = chromium-linux;
  x86_64-darwin = chromium-darwin;
  aarch64-darwin = chromium-darwin;
}
.${system} or throwSystem
