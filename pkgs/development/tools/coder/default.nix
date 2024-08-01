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
      version = "2.11.4";
      hash = {
        x86_64-linux = "sha256-um7bwlHzPh6dF2KspGLQfzSVywWdImUc0U/HTkWT2jA=";
        x86_64-darwin = "sha256-AiT63c47obiGnf9Vo0C2F3YoVLWdbH/+pkgFT0Tvzew=";
        aarch64-linux = "sha256-7tl58GmO5pBsjSkiF/Oy1r3a+Giko/+2Ir7r4V6vy4c=";
        aarch64-darwin = "sha256-e86dqZptcQeGlCclLRfNW3Ku9UucW0vXHBGC7r/0Apc=";
      };
    };
    mainline = {
      version = "2.12.3";
      hash = {
        x86_64-linux = "sha256-cg2Xr4yZXVFl081fGYztDa35TnaQYmS/uMqc1z5UAmc=";
        x86_64-darwin = "sha256-zK/I/D5N5hcFMrBxebaA5WSRml0RaKrSX1FI/+YSXxI=";
        aarch64-linux = "sha256-KRIdyQFTBmhEm0hkdoilYNlQhcpagilc5fZ6k18Riu4=";
        aarch64-darwin = "sha256-4q6Sz+ZguMxznPuwf0Ip+KWTDKPPZ/ICdvltVLmQinE=";
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
  };
})
