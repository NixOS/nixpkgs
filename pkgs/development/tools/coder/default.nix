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
      version = "2.18.3";
      hash = {
        x86_64-linux = "sha256-ehQvvtEiaFyTZWG1BlFbX2lx7uTG7GrsnZ6cv2m57zY=";
        x86_64-darwin = "sha256-pR8kgbIakBaXhcnCOV9Y84ryX9trFe2Y8Mfx4YV2Nvs=";
        aarch64-linux = "sha256-4rAwZ/YXRDeuOnlEhV+jo0LrIrYN5KkKN44rS2T3xdg=";
        aarch64-darwin = "sha256-r+IqiXPUQHq1Ta60PNLQ+uvXJyjXUWKjXcJyujsAhtk=";
      };
    };
    mainline = {
      version = "2.18.3";
      hash = {
        x86_64-linux = "sha256-ehQvvtEiaFyTZWG1BlFbX2lx7uTG7GrsnZ6cv2m57zY=";
        x86_64-darwin = "sha256-pR8kgbIakBaXhcnCOV9Y84ryX9trFe2Y8Mfx4YV2Nvs=";
        aarch64-linux = "sha256-4rAwZ/YXRDeuOnlEhV+jo0LrIrYN5KkKN44rS2T3xdg=";
        aarch64-darwin = "sha256-r+IqiXPUQHq1Ta60PNLQ+uvXJyjXUWKjXcJyujsAhtk=";
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
