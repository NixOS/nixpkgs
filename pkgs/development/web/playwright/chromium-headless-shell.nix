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
          x86_64-linux = "sha256-Nr0/uczFTBTqvRPR0c/wflIqG5relgKfC9XsMOdE9iE=";
          aarch64-linux = "sha256-veEBmsivFDrG1bArQ780+gMbsoT1Zv4VLcIPpgn4M/I=";
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
    inherit (download) url stripRoot;
    hash =
      {
        x86_64-darwin = "sha256-GEomMUuaIjhBEuWF/HyMohseJtwKOn5MCgh6kIB9ZeE=";
        aarch64-darwin = "sha256-7laJtPAiy6pYAxCNBxRYk+FmriXemmLW8UYteEdVrd0=";
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
