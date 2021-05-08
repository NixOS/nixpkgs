{ buildGoModule, fetchFromGitHub, stdenv, lib }:

buildGoModule rec {
  pname = "fly";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-uKzN5h2gJqsD25ETgfYqu4ijC2b0ZLGdMGTiliFOatA=";
  };

  vendorSha256 = "sha256-2PvXylOPVA0/mIQhhKv8o65bfAxkvKP6FPunzTWwVtI=";

  doCheck = false;

  subPackages = [ "fly" ];

  buildFlagsArray = ''
    -ldflags=
      -X github.com/concourse/concourse.Version=${version}
  '';

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
