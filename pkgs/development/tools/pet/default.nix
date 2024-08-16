{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "pet";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-XFizQxegyMIAUEKT8/kzWyC4TWICMUE7SuHQsTNpK4w=";
  };

  vendorHash = "sha256-XvSg7EhFdK7wt1Eei56pj/emiE4qsVJkOpgPNsnDNc4=";

  ldflags = [
    "-s" "-w" "-X=github.com/knqyf263/pet/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pet \
      --zsh ./misc/completions/zsh/_pet
  '';

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    mainProgram = "pet";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
