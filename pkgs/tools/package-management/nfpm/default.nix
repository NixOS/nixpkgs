{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "nfpm";
  version = "2.33.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5CNN0aKy9FnoqRwhbNVTUs04q+hkzoAWlDuDKMeT+1s=";
  };

  vendorHash = "sha256-P96qMc9KHDMreuPI3xY/yI/+8qp/znQM/O2B6t6iFug=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      ${emulator} $out/bin/nfpm man > nfpm.1
      installManPage ./nfpm.1
      installShellCompletion --cmd nfpm \
        --bash <(${emulator} $out/bin/nfpm completion bash) \
        --fish <(${emulator} $out/bin/nfpm completion fish) \
        --zsh  <(${emulator} $out/bin/nfpm completion zsh)
    '';

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    changelog = "https://github.com/goreleaser/nfpm/releases/tag/v${version}";
    maintainers = with maintainers; [ marsam techknowlogick caarlos0 ];
    license = with licenses; [ mit ];
  };
}
