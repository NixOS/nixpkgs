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
          x86_64-linux = "sha256-2w0Ul3tpzrVkfGHIbQGwEsCRmVUUy3OAShGhuoH6Rmw=";
          aarch64-linux = "sha256-DoZf+pKXW0Oj2e8vtGDDSViJ0SX8PkYE1Q0LJs53IWg=";
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
        aarch64-darwin = "sha256-5VQESywHZKhqc7Fhq/jqNF+yXl90F3+i9nPzBHyJV8k=";
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
