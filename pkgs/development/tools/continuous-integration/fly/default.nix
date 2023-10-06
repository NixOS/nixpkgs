{ buildGoModule, fetchFromGitHub, stdenv, lib, installShellFiles }:

buildGoModule rec {
  pname = "fly";
  version = "7.10.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    hash = "sha256-KmKIr7Y3CQmv1rXdju6xwUHABqj/dkXpgWc/yNrAza8=";
  };

  vendorHash = "sha256-lc0okniezfTNLsnCBIABQxSgakRUidsprrEnkH8il2g=";

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
