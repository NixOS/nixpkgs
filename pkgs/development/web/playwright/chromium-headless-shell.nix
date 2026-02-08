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
  libxcomposite,
  libxdamage,
  libxfixes,
  libxrandr,
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
          x86_64-linux = "sha256-4xPtmjRSbkWLmV2LzVClwjeQcmktZCvDS3gYo+FlkJc=";
          aarch64-linux = "sha256-rnurwOiST8fdAC5kGC9uR+MRidGtIZCPQLrg+xZbuZQ=";
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
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
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
        x86_64-darwin = "sha256-9MsBmUuaHq3P/eWxGcihzk09e1zuEr4dIMo6ZjSM8ZQ=";
        aarch64-darwin = "sha256-i8L+C4p8DCcqb5C5B5q+JuX/fTPxhBva2dlFVDkdfQ0=";
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
