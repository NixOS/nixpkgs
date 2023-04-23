{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:
buildGoModule rec {
  pname = "goreleaser";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tNu2rZKGUdBlhY8GmTNM48Nk1DPNp7uChe0v112fhyY=";
  };

  vendorHash = "sha256-KNHi8lSsya/vbpsWbr7un3bKsb6GcyhkrTurRhczxns=";

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
