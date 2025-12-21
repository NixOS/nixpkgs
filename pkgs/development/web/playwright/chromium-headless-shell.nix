{
  fetchzip,
  revision,
  suffix,
  system,
  throwSystem,
  stdenv,
  autoPatchelfHook,
  patchelfUnstable,

  alsa-lib,
  at-spi2-atk,
  glib,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXrandr,
  libgbm,
  libgcc,
  libxkbcommon,
  nspr,
  nss,
  ...
}:
let
  linux = stdenv.mkDerivation {
    name = "playwright-chromium-headless-shell";
    src = fetchzip {
      url = "https://playwright.azureedge.net/builds/chromium/${revision}/chromium-headless-shell-${suffix}.zip";
      stripRoot = false;
      hash =
        {
          x86_64-linux = "sha256-khYVM0jocno97lV8mRH71WHzopIjnq3eX/PD1kQuZnE=";
          aarch64-linux = "sha256-1G0UAIFmBcij0EXq1VVxvku5iQmGGWvQxdBT+zRW0ZM=";
        }
        .${system} or throwSystem;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      patchelfUnstable
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      glib
      libXcomposite
      libXdamage
      libXfixes
      libXrandr
      libgbm
      libgcc.lib
      libxkbcommon
      nspr
      nss
    ];

    buildPhase = ''
      cp -R . $out
    '';
  };

  darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/chromium/${revision}/chromium-headless-shell-${suffix}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-R4XdK3wD3eoNREydU34MkrvCkI2VqSxIiM7Zhf5EvjM=";
        aarch64-darwin = "sha256-8CyMLQdtWhMUxwd6UWQ7vGtyi69mCxEA6WwXk2S82qA=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = linux;
  aarch64-linux = linux;
  x86_64-darwin = darwin;
  aarch64-darwin = darwin;
}
.${system} or throwSystem
