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
          x86_64-linux = "sha256-Qiz/wZA9AsYfqsEej5zfNxVcieu20J2m4XVFRA34Bi4=";
          aarch64-linux = "sha256-I7gSc1J6+KJbRiANE997p34vAQj62bF3CQn0LZFTsqA=";
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
        aarch64-darwin = "sha256-47hkERfQBDHWjD6VFwQNVCAXK1a+5uWKmNwialEESso=";
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
