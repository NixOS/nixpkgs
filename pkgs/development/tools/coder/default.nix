{ lib
, channel ? "stable"
, fetchurl
, installShellFiles
, makeBinaryWrapper
, terraform
, stdenvNoCC
, unzip
, nixosTests
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  channels = {
    stable = {
      version = "2.17.3";
      hash = {
        x86_64-linux = "sha256-Okkw13WRIS9OWmS8rSnoVWlNROQhYlMIqmXRAdcgpGM=";
        x86_64-darwin = "sha256-B+bqvQcVb5yMO66OImoNIRolRHqaFSZaBNSWAE5hHzE=";
        aarch64-linux = "sha256-t94MGHh8a2cUtdv+vZ687sR47oMSvfOEvuJ6syUZ8SQ=";
        aarch64-darwin = "sha256-nfg+tyYV2h+K1u+6DcG36juEelK/9viL657RP74/L8s=";
      };
    };
    mainline = {
      version = "2.18.1";
      hash = {
        x86_64-linux = "sha256-nZZx0QD6lpg/+uBEYmFvO16Y80CscAovSuq6ws5y+Xo=";
        x86_64-darwin = "sha256-CD/s8C1RcU2cF6MRsiFwIDcyYS9Ef4eEo1h1ZRPRcYI=";
        aarch64-linux = "sha256-G2wpfyCXAx5j/VAFXLeElq9zfheaScU/sNheu6EosqU=";
        aarch64-darwin = "sha256-cgEGZFfNph25LgXpZ+FReZdBfGFLjteWqNY2WGQdPTM=";
      };
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coder";
  version = channels.${channel}.version;
  src = fetchurl {
    hash = (channels.${channel}.hash).${system};

    url =
      let
        systemName = {
          x86_64-linux = "linux_amd64";
          aarch64-linux = "linux_arm64";
          x86_64-darwin = "darwin_amd64";
          aarch64-darwin = "darwin_arm64";
        }.${system};

        ext = {
          x86_64-linux = "tar.gz";
          aarch64-linux = "tar.gz";
          x86_64-darwin = "zip";
          aarch64-darwin = "zip";
        }.${system};
      in
      "https://github.com/coder/coder/releases/download/v${finalAttrs.version}/coder_${finalAttrs.version}_${systemName}.${ext}";
  };

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    unzip
  ];

  unpackPhase = ''
    runHook preUnpack

    case $src in
        *.tar.gz) tar -xz -f "$src" ;;
        *.zip)    unzip      "$src" ;;
    esac

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 coder $out/bin/coder

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/coder \
      --prefix PATH : ${lib.makeBinPath [ terraform ]}
  '';

  # integration tests require network access
  doCheck = false;

  meta = {
    description = "Provision remote development environments via Terraform";
    homepage = "https://coder.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "coder";
    maintainers = with lib.maintainers; [ ghuntley kylecarbs urandom ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) coder;
    };
  };
})
