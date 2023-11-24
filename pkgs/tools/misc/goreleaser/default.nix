{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
, testers
, goreleaser
}:
buildGoModule rec {
  pname = "goreleaser";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Okuiicq1CAVrE3YPe/aF/HZbf23p6ulz//BRGX77cnw=";
  };

  vendorHash = "sha256-+ac4q820gETsNRVpW2u0MXU6HfoztLdsWK2HYqJ4mqo=";

  ldflags =
    [ "-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs" ];

  # tests expect the source files to be a build repo
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      ${emulator} $out/bin/goreleaser man > goreleaser.1
      installManPage ./goreleaser.1
      installShellCompletion --cmd goreleaser \
        --bash <(${emulator} $out/bin/goreleaser completion bash) \
        --fish <(${emulator} $out/bin/goreleaser completion fish) \
        --zsh  <(${emulator} $out/bin/goreleaser completion zsh)
    '';

  passthru.tests.version = testers.testVersion {
    package = goreleaser;
    command = "goreleaser -v";
    inherit version;
  };

  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [
      c0deaddict
      endocrimes
      sarcasticadmin
      techknowlogick
      developer-guy
      caarlos0
    ];
    license = licenses.mit;
  };
}
