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
      version = "2.18.5";
      hash = {
        x86_64-linux = "sha256-thoe1TYT4b2tm1t9ZTGGMl9AzW/zP74LavIYweUs8Yw=";
        x86_64-darwin = "sha256-HOHNzUKSt1ZO2onmydeHDeYdekwxfyy19Ps4q8xdurI=";
        aarch64-linux = "sha256-dU6XdW/uOHMgSTnokvw9bDGULQM4urm8Szc7RRUEEcs=";
        aarch64-darwin = "sha256-u1/yWTZv0NgviED6+VywONPv4CJsgWBpXjstyL1dBg4=";
      };
    };
    mainline = {
      version = "2.18.5";
      hash = {
        x86_64-linux = "sha256-thoe1TYT4b2tm1t9ZTGGMl9AzW/zP74LavIYweUs8Yw=";
        x86_64-darwin = "sha256-HOHNzUKSt1ZO2onmydeHDeYdekwxfyy19Ps4q8xdurI=";
        aarch64-linux = "sha256-dU6XdW/uOHMgSTnokvw9bDGULQM4urm8Szc7RRUEEcs=";
        aarch64-darwin = "sha256-u1/yWTZv0NgviED6+VywONPv4CJsgWBpXjstyL1dBg4=";
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
