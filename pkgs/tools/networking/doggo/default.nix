{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "doggo";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "mr-karan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6jNs8vigrwKk47Voe42J9QYMTP7KnNAtJ5vFZTUW680=";
  };

  vendorSha256 = "sha256-pyzu89HDFrMQqYJZC2vdqzOc6PiAbqhaTgYakmN0qj8=";
  nativeBuildInputs = [ installShellFiles ];
  subPackages = [ "cmd/doggo" ];

  ldflags = [
    "-w -s"
    "-X main.buildVersion=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd doggo \
      --fish --name doggo.fish completions/doggo.fish \
      --zsh --name _doggo completions/doggo.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/mr-karan/doggo";
    description = "Command-line DNS Client for Humans. Written in Golang";
    longDescription = ''
      doggo is a modern command-line DNS client (like dig) written in Golang.
      It outputs information in a neat concise manner and supports protocols like DoH, DoT, DoQ, and DNSCrypt as well
    '';
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ georgesalkhouri ];
  };
}
