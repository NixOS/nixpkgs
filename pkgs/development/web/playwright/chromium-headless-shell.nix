{
  fetchzip,
  revision,
  browserVersion,
  system,
  throwSystem,
  stdenv,
  autoPatchelfHook,
  patchelfUnstable,

  alsa-lib,
  at-spi2-atk,
  expat,
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
  download =
    (import ./browser-downloads.nix {
      name = "chromium-headless-shell";
      inherit revision browserVersion;
    }).${system} or throwSystem;

  linux = stdenv.mkDerivation {
    name = "playwright-chromium-headless-shell";
    src = fetchzip {
      inherit (download) url stripRoot;
      hash =
        {
          x86_64-linux = "sha256-pcaNqbYfyrcgiDvpZJKSpVzF1byesfwDzJBNk5Srh9Q=";
          aarch64-linux = "sha256-vbPWUHPvfEnL432TlPN76AjOn9OQaGVU6DY7IvTmcvo=";
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
      expat
      glib
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      libgbm
      libgcc
      libxkbcommon
      nspr
      nss
    ];

    buildPhase = ''
      cp -R . $out
    '';
  };

  darwin = fetchzip {
    inherit (download) url stripRoot;
    hash =
      {
        aarch64-darwin = "sha256-KVBu5W3+034PE+391pr4DzDbpoO+Ce3xP08tgmdveJM=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = linux;
  aarch64-linux = linux;
  aarch64-darwin = darwin;
}
.${system} or throwSystem
