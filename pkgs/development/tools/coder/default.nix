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
      version = "2.18.2";
      hash = {
        x86_64-linux = "sha256-/bfn6eE0aFGbpmtcgDmtTaGsIVQTQC59mmxRcKW67mI=";
        x86_64-darwin = "sha256-skRiwGEvN6NZn5P+KPlSko3oO3ljC0+1lQvMv+mhCU4=";
        aarch64-linux = "sha256-Txs8LYK712zgHl3nQZ58I91zXiMokfYHpDD6V295TjY=";
        aarch64-darwin = "sha256-RGm0Yh2P1IUc5+0G2iRu+6dVIZUlFW4rIODLaEhc0vA=";
      };
    };
    mainline = {
      version = "2.18.2";
      hash = {
        x86_64-linux = "sha256-/bfn6eE0aFGbpmtcgDmtTaGsIVQTQC59mmxRcKW67mI=";
        x86_64-darwin = "sha256-skRiwGEvN6NZn5P+KPlSko3oO3ljC0+1lQvMv+mhCU4=";
        aarch64-linux = "sha256-Txs8LYK712zgHl3nQZ58I91zXiMokfYHpDD6V295TjY=";
        aarch64-darwin = "sha256-RGm0Yh2P1IUc5+0G2iRu+6dVIZUlFW4rIODLaEhc0vA=";
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
