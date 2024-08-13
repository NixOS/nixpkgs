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
      version = "2.13.4";
      hash = {
        x86_64-linux = "sha256-vIqqVVJxKlxiKWsb9soy6yZQ9NQ8ZCjUqzu6k8m9MJE=";
        x86_64-darwin = "sha256-m7ZMVEaqIvmutTaQk3r8/p8h5zt4k/s34IdKjv89awA=";
        aarch64-linux = "sha256-fBHZijXeqRNr9zvmgaFhMaIIF9kgP7J32CwJgBvf9/0=";
        aarch64-darwin = "sha256-3QnxGDV4VRlxw3BayYD4akC6ZRjaUhEkptTGt3Zzecg=";
      };
    };
    mainline = {
      version = "2.14.1";
      hash = {
        x86_64-linux = "sha256-zOMcngzhG6SxN/Hjamf5g0Cb/nhrD3NcVKC8MdL2L80=";
        x86_64-darwin = "sha256-FzFrE3moll8D0of0Chs47XI9baAjFDzpcPJdpwteMpE=";
        aarch64-linux = "sha256-RsQ3sv5t+o6gObdG81hZ8dHng39qjlynENH30oAhZqM=";
        aarch64-darwin = "sha256-MPIm/d6fOe6DjVIewDeoxMs2OKz9urWgKMW6vmM9RGs=";
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
