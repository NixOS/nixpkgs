{ buildGoModule, fetchFromGitHub, stdenv, lib, installShellFiles }:

buildGoModule rec {
  pname = "fly";
  version = "7.9.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "sha256-YatN0VG3oEUK+vzJzthRnX+EkvUgKq2uIunAoPMoRag=";
  };

  vendorSha256 = "sha256-nX0r/7V+rgJb3/9O91QskYzBpWXIca7m3Do1QtGuHgg=";

  subPackages = [ "fly" ];

  ldflags = [
    "-s" "-w" "-X github.com/concourse/concourse.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fly \
      --bash <($out/bin/fly completion --shell bash) \
      --fish <($out/bin/fly completion --shell fish) \
      --zsh <($out/bin/fly completion --shell zsh)
  '';

  meta = with lib; {
    description = "Command line interface to Concourse CI";
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan SuperSandro2000 ];
  };
}
