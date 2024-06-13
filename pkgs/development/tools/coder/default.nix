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
      version = "2.11.2";
      hash = {
        x86_64-linux = "sha256-kvQPrYGDkfzTOb3c9f3VNdg3oltKmm1Z4pXeHJ9LIyo=";
        x86_64-darwin = "sha256-AUfbdJNBK2fCJ6Pq4gkH4+y/undu6Nx64wcejVAB7iU=";
        aarch64-linux = "sha256-FWgTLE3fW/6j1W1FNDqyVOTMGuFqc4e3Eq2tj8IEcWk=";
        aarch64-darwin = "sha256-oM+dEUYNUcYHemDWYBf5mqUo3aHXEu6LUuLOboGfTrQ=";
      };
    };
    mainline = {
      version = "2.12.1";
      hash = {
        x86_64-linux = "sha256-YOm2qpw9c5L0bwcodR0quUO2d0eRqDBeUfGB6bZNC9I=";
        x86_64-darwin = "sha256-ePpwnXoVQby0l4Az8OtygPBpXumjIR8MaDVPH4FzrwM=";
        aarch64-linux = "sha256-ZPAWzLjtJsgtcMT+w2n8o4cQtQ7HXrL+EejOib/Ab3c=";
        aarch64-darwin = "sha256-ZcJiLLcZcge0MXiuQH4slAqxXLuytdHL+LZfUNx25jY=";
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
