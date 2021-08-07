{ buildGoModule, fetchFromGitHub, stdenv, lib }:

buildGoModule rec {
  pname = "fly";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-UvEPTZtQWztl7ZC1XrBxE8+emlXQjMG4IJEti5vVxUM=";
  };

  vendorSha256 = "sha256-IY+HGgoKNS/j3FGCX3F3EK1GehBjs3Z1K8V3O7a3swk=";

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
