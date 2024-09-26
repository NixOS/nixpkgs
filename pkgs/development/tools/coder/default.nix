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
      version = "2.14.3";
      hash = {
        x86_64-linux = "sha256-CDQmixywYDLj3ABqTEnaUftITSFGA/wGAfe0IFoU64g=";
        x86_64-darwin = "sha256-TDpoby2lBw8W6zJrHgF/AQFQL+j9dv3d21VLsiSd1sk=";
        aarch64-linux = "sha256-L+2YOMgH1cCl4o1VFZk1dC258/XStgiH9lr9PEQOPSo=";
        aarch64-darwin = "sha256-hG3HsJ+DIjwB5ehT+Hd3EZduvjNXYTZLYbAYCRWWiQ8=";
      };
    };
    mainline = {
      version = "2.15.0";
      hash = {
        x86_64-linux = "sha256-zM5l3vkLKuDdZHTgVTYfvfYTGLCpDnA2GZDh5PLQ9rs=";
        x86_64-darwin = "sha256-AbW92RMaPfusve5DxRaT3npeN2zVzrBOBL3XGN8235I=";
        aarch64-linux = "sha256-13FZc1zMmaxfDp0bXBFzf2gcO6wkiA932C5m9oon2GQ=";
        aarch64-darwin = "sha256-UP08DncRvM1NjtMOfanDnXGySK1RrCUta5lbIvJ7vto=";
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
