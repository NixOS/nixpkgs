{
  runCommand,
  makeWrapper,
  fontconfig_file,
  chromium,
  fetchzip,
  revision,
  browserVersion,
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
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
  ...
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "chromium";
      inherit revision browserVersion;
    }).${system} or throwSystem;

  # Playwright expects different directory names for different architectures:
  # - linux-x64 expects: chrome-linux64
  # - linux-arm64 expects: chrome-linux
  chromeDir =
    {
      x86_64-linux = "chrome-linux64";
      aarch64-linux = "chrome-linux";
    }
    .${system} or throwSystem;

  chromium-linux = stdenv.mkDerivation {
    name = "playwright-chromium";
    src = fetchzip {
      inherit (download) url stripRoot;
      hash =
        {
          x86_64-linux = "sha256-dJSO05xOzlSl/EwOWNQCeuSb+lhUU6NlGBnRu59irnM=";
          aarch64-linux = "sha256-9DFLCPuc9WZjYLzlRW+Df2pb+mViPK3/IOkkUozELsw=";
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
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/${chromeDir}
      cp -R . $out/${chromeDir}

      wrapProgram $out/${chromeDir}/chrome \
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
      rm "$out/${chromeDir}/libvulkan.so.1"
      ln -s -t "$out/${chromeDir}" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    '';
  };
  chromium-darwin = fetchzip {
    inherit (download) url stripRoot;
    hash =
      {
        x86_64-darwin = "sha256-vQuBHM0jkk6S/Gco/bBqSPJqXi/CJt/+nkbGtFNpgwk=";
        aarch64-darwin = "sha256-qXdgHeBS5IFIa4hZVmjq0+31v/uDPXHyc4aH7Wn2E7E=";
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
