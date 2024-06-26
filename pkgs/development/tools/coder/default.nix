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
      version = "2.11.3";
      hash = {
        x86_64-linux = "sha256-TaEl7J/Zo/K+j8EGpIauQYR5UucALviuSk0/jgiK83U=";
        x86_64-darwin = "sha256-qM2YTvHGeAi1F4V79YoDdsp1NbHFah8L0bppUhmzZyY=";
        aarch64-linux = "sha256-gLaxi3h2JrnVecS/k3YHuWM1R1oLXKg5R1aeh3GVREY=";
        aarch64-darwin = "sha256-SochFDBspdKfw1xd2FiyI9bp2Y3SbdgbGtzwUDyMsLE=";
      };
    };
    mainline = {
      version = "2.12.2";
      hash = {
        x86_64-linux = "sha256-UJnJ64zwuDKzc/yKLQnj//3tXZ/GJpzUUw8KoH3Uf14=";
        x86_64-darwin = "sha256-d+BWUEMvta7ZkCOqMTafuR5suIDWPauwTzGOpPDF+ck=";
        aarch64-linux = "sha256-ayZZhqL3YLjaUDmHOiY4yXg/+tGR7HpLcwojuagqkKg=";
        aarch64-darwin = "sha256-EYB7YLScshBInLBOXVfYs+f+OWC7OF9tEmhhG25pPSo=";
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
