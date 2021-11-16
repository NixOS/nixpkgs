{ buildGoModule, fetchFromGitHub, stdenv, lib }:

buildGoModule rec {
  pname = "fly";
  version = "7.6.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-Zi+gyO+2AKDgcfgYrzLskJYZ6hQKOVlOL7Y9nxH/pGg=";
  };

  vendorSha256 = "sha256-OF3parnlTPmcr7tVcc6495sUMRApSpBHHjSE/4EFIxE=";

  doCheck = false;

  subPackages = [ "fly" ];

  ldflags = [
    "-X github.com/concourse/concourse.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}
    $out/bin/fly completion --shell bash > $out/share/bash-completion/completions/fly
    $out/bin/fly completion --shell zsh > $out/share/zsh/site-functions/_fly
  '';

  meta = with lib; {
    description = "A command line interface to Concourse CI";
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan ];
  };
}
