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
      version = "2.19.1";
      hash = {
        x86_64-linux = "sha256-w8yET4jpuNn/DswFlJ8QpKS5YjI9gs0OTmQ0D1f5JZE=";
        x86_64-darwin = "sha256-2ttVjvemACsRLoRE7wMmgsUUDM2AFNo5lXG1kCL8Ae8=";
        aarch64-linux = "sha256-8BJrMj0s2MzgCueWlWsGKntEkBwW7rBYZF+5O3lVLN0=";
        aarch64-darwin = "sha256-9v0OzQMGq92lNKsOevpE1jjwto+ETgfmVmK5p+JdVBI=";
      };
    };
    mainline = {
      version = "2.20.0";
      hash = {
        x86_64-linux = "sha256-Vk2Qhk4eNf9Akwza0QNuAc/lh2BtU0sd6QSS2IIyZo4=";
        x86_64-darwin = "sha256-TVQYQOqJj9gnTt5HaVVjyr7sBPD3mAPpy5vNw9RJ7dc=";
        aarch64-linux = "sha256-hBp7lVaJk30KD8eQ4ehoI1/DW28SWQisGtY4lJNVETw=";
        aarch64-darwin = "sha256-pvFZELrXk1bf5nfbDskY3bpSCv22Ls0Leo11Dgu/dfI=";
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
