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
      version = "2.13.5";
      hash = {
        x86_64-linux = "sha256-drg19B1YTjpLvKDGE8B38T08KyMvuoAse5hQzDaJn5k=";
        x86_64-darwin = "sha256-wj1zW6pJBx7eTFxdjBNiS6g+uixCUd1+O969K4JDj1k=";
        aarch64-linux = "sha256-z2iiz5RWoVsDkwKCvDYbFRsLyiIBhJKrCo6p8d4ImMg=";
        aarch64-darwin = "sha256-akuXh/izu9S9UQfIWhfdfcuez4FhZBz5PE5g9WmtpoQ=";
      };
    };
    mainline = {
      version = "2.14.2";
      hash = {
        x86_64-linux = "sha256-Qglz8F80QICwWOVwDELegewYHkPhhrTEuGKJgiw2mYg=";
        x86_64-darwin = "sha256-uyslQIAXOROSdtyiLSUcxEwYzK+iDup8/jRI74QGcEo=";
        aarch64-linux = "sha256-rzTBfO8+DSxJjhjIhl8qNji8bWe/EGZ4dG17D8wjlkA=";
        aarch64-darwin = "sha256-+lFWz6qDuhtDNn7DID/lmpqltpEwftVP3U+2CseVMnY=";
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
