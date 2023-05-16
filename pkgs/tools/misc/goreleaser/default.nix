{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:
buildGoModule rec {
  pname = "goreleaser";
<<<<<<< HEAD
  version = "1.20.0";
=======
  version = "1.18.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "iZqX/03+0koxLTbeUOxpQoEita6S/eszB8kMe/NtDcc=";
  };

  vendorHash = "sha256-YYFCoLwgx8OBfI4VcWO6AUqNZU2JdgGAJm26koJAzWA=";
=======
    sha256 = "sha256-OvGPE6U/OeY1KcUFjR9CCBd0WOo2Rd4349wBm9SN8bo=";
  };

  vendorHash = "sha256-0hT7wraXTUAGMJdAw3xkGzojpXnwaEOoHnW28DrA1QQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
