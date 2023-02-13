{ lib, fetchFromGitHub, installShellFiles, buildGoModule }:

buildGoModule rec {
  pname = "autorestic";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "cupcakearmy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gf2sqMI8dG7+sVSqe2f5oG7vqQ9UDKAqPUS+MPVB7SI=";
  };

  vendorHash = "sha256-eB24vCElnnk3EMKniCblmeRsFk0BQ0wFeBf0B8OPanE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd autorestic \
         --bash <($out/bin/autorestic completion bash) \
         --fish <($out/bin/autorestic completion fish) \
         --zsh <($out/bin/autorestic completion zsh)
  '';

  meta = with lib; {
    description = "High level CLI utility for restic";
    homepage = "https://github.com/cupcakearmy/autorestic";
    license = licenses.asl20;
    maintainers = with maintainers; [ renesat ];
    mainProgram = "autorestic";
  };
}
