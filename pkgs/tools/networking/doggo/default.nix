{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  installShellFiles,
}: let
  buildDate = "2022-08-15T21:36:49";
  buildCommit = "2cf9e7b";
in
  with lib;
    buildGoModule rec {
      pname = "doggo";
      version = "0.5.4";
      vendorSha256 = "sha256-pyzu89HDFrMQqYJZC2vdqzOc6PiAbqhaTgYakmN0qj8=";
      src = fetchFromGitHub {
        owner = "mr-karan";
        repo = "doggo";
        rev = "v0.5.4";
        sha256 = "sha256-6jNs8vigrwKk47Voe42J9QYMTP7KnNAtJ5vFZTUW680=";
      };

      nativeBuildInputs = [installShellFiles];
      subPackages = ["cmd/doggo"];

      ldflags = [
        "-w -s"
        "-X main.buildVersion=${buildCommit}"
        "-X main.buildDate=${buildDate}"
      ];

      postInstall = ''
        installShellCompletion --cmd doggo --fish --name doggo.fish completions/doggo.fish
        installShellCompletion --cmd doggo --zsh --name _doggo completions/doggo.zsh
      '';

      meta = {
        homepage = "https://github.com/mr-karan/doggo";
        description = "Command-line DNS Client for Humans. Written in Golang";
        longDescription = ''
          doggo is a modern command-line DNS client (like dig) written in Golang.
          It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
        '';
        license = licenses.gpl3Only;
        platforms = platforms.linux;
        maintainers = with maintainers; [georgesalkhouri];
      };
    }
