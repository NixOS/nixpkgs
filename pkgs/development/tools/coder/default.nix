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
      version = "2.16.1";
      hash = {
        x86_64-linux = "sha256-Mv+4xFuilzGU4ccDhc+Xhk5+cN8ixA8Api5yOJtQ2xY=";
        x86_64-darwin = "sha256-it+XaD9Zn9mJQpS+sNN2dGVH0pGDyv/UnOPZQ2hnk0c=";
        aarch64-linux = "sha256-HzS7NKnaglzctEFLnmMDV6P4BPNOqqCvT1Y6iO/+a2s=";
        aarch64-darwin = "sha256-/tKiFVr06EkAOctrQ3n3GjFT7BryJfYVUkP/Tqw2IE4=";
      };
    };
    mainline = {
      version = "2.17.2";
      hash = {
        x86_64-linux = "sha256-IhR6C9qwe6p4svdXR+BreFTeJb0MYOEgjIVE3JHH4XA=";
        x86_64-darwin = "sha256-titICVmAfXP306Mj9vFHPGtA4T85BncHta944qyEPZI=";
        aarch64-linux = "sha256-bvCBO4IcmCi5jgdNXsManCXErV4raKUoiwHLP9GHZhk=";
        aarch64-darwin = "sha256-3pC5oryN8wDNHuaWJBkUUOLy3HbnCEIsLXbzzuwfuPY=";
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
