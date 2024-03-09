{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "nfpm";
  version = "2.35.3";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QoZiI9rMOdQZbMENVcBfUYPAvN9IqfeR0EK11l8+Hzo=";
  };

  vendorHash = "sha256-WYuhHLq0/OD/JtOEkZsyPEJyjPqEoh9RSfBG0G3E/2w=";

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
    mainProgram = "nfpm";
  };
}
