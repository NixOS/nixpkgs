{ buildGoModule, fetchFromGitHub, stdenv, lib }:

buildGoModule rec {
  pname = "fly";
  version = "7.7.1";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-AJvD9re4jj+ixvZKWHDJM0QEv5EPFv3VFJus3lnm2LI=";
  };

  vendorSha256 = "sha256-G9HdhPi4iezUR6SIVYnjL0fznOfiusY4T9ClLPr1w5c=";

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
