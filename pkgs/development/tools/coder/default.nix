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
      version = "2.15.1";
      hash = {
        x86_64-linux = "sha256-DB/3iUkgWzAI+3DEQB8heYkG6apUARDulQ4lKDAPN1I=";
        x86_64-darwin = "sha256-62tjAC3WtWC8eIkh9dPi2Exksp2gDHyXEU2tCavKZ4Q=";
        aarch64-linux = "sha256-957GdH5sDjbjxEt8LXKPBM7vht7T6JizVwYYhbitdpw=";
        aarch64-darwin = "sha256-ckcd1u9dgg9LKhr47Yw8dJKkR7hawPie4QNyySH8vyM=";
      };
    };
    mainline = {
      version = "2.16.0";
      hash = {
        x86_64-linux = "sha256-Uk9oGiLSHBCINAzQg88tlHyMw/OGfdmCw2/NXJs5wbQ=";
        x86_64-darwin = "sha256-Bbayv00NDJGUA4M4KyG4XCXIiaQSf4JSgy5VvLSVmAM=";
        aarch64-linux = "sha256-nV02uO+UkNNvQDIkh2G+9H8gvk9DOSYyIu4O3nwkYXk=";
        aarch64-darwin = "sha256-C9Nm8dW3V25D7J/3ABO5oLGL4wcSCsAXtQNZABwVpWs=";
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
