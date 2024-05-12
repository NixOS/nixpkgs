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
      version = "2.10.2";
      hash = {
        x86_64-linux = "sha256-U3qHEjIKq8JkpDp6TehMs6t5L3GpSGt4D10XSAQ9Ii0=";
        x86_64-darwin = "sha256-ibfqqxRRD3IfIN2FqSxk5qd7d87RvBgKKFv9F0hACgo=";
        aarch64-linux = "sha256-HdBVnLKen6W1crZfnc2hpA0cAYIYeYFHKvANwnLqkjY=";
        aarch64-darwin = "sha256-3sHmR6PTRlBSIdD4rja4y8v0gOY4cbbyhW7qssgpqp8=";
      };
    };
    mainline = {
      version = "2.11.0";
      hash = {
        x86_64-linux = "sha256-aJwL4WCJXxSBrfaUHEECQqedz2lKBOa8sdRItSBpxp4=";
        x86_64-darwin = "sha256-4D4MoDrEJtawFeUBG9BiJ6HZ9uqx9uQDIHHNB7m2pp8=";
        aarch64-linux = "sha256-2UlCxykSfnK50OPb61YC42MTTlPL1njf0vpwmqaUbI8=";
        aarch64-darwin = "sha256-mh0Lr+SH4jZTx1xH7QoqfSLDma5nS61sv31QuOYAgQk=";
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
