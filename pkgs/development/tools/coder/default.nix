{ lib
, channel ? "stable"
, fetchurl
, installShellFiles
, makeBinaryWrapper
, terraform
, stdenvNoCC
, unzip
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  channels = {
    stable = {
      version = "2.9.3";
      hash = {
        x86_64-linux = "sha256-6VS21x2egWBV6eJqRCBGG7mEGPIDFtY9GN6Ry4ilC70=";
        x86_64-darwin = "sha256-UBUGjA+jUkT6p9714l8IvDDI/qhWNctVFOvcA2S5kQU=";
        aarch64-linux = "sha256-2QAahqcM2gi3lT+18q2Nm9GNqVsqzX3RajBsTn+KB1c=";
        aarch64-darwin = "sha256-uEH7Y7c9BcU/Q/jwx/inFMvUrgm2dUruID+FJL+rA6Y=";
      };
    };
    mainline = {
      version = "2.10.1";
      hash = {
        x86_64-linux = "sha256-jNPL30e5xvyajlIqivtEpSb3cRhfgFhLFlC+CaLY2IM=";
        x86_64-darwin = "sha256-U1eQaYwnm/mdQoZ8YxK/+s3HboVfMIAtdI7aQnCiDM8=";
        aarch64-linux = "sha256-YtSyKZYG8vdubZUfo2FjEoVwSF82TXzeLJjPpHqgFDk=";
        aarch64-darwin = "sha256-aQSiXK7voP5/mPFIscfTnSc4Ae5/f+WW8MR6ZtuC/eY=";
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
    installShellCompletion --cmd coder \
      --bash <($out/bin/coder completion bash) \
      --fish <($out/bin/coder completion fish) \
      --zsh <($out/bin/coder completion zsh)

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
  };
})
