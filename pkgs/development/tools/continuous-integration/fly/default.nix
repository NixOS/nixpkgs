{ buildGoModule, fetchFromGitHub, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "15lkhdvxqcryn5k7qflkby666ddj66gpqzga13yxjgjjp7zx2mi3";
  };

  modSha256 = "0wz0v7w2di23cvqpg35zzqs2hvsbjgcrl7pr90ymmpsspq97fkf7";

  subPackages = [ "fly" ];

  buildFlagsArray = ''
    -ldflags=
      -X github.com/concourse/concourse.Version=${version}
  '';

  # The fly.bash file included with this derivation can be replaced by a
  # call to `fly completion bash` once the `completion` subcommand has
  # made it into a release. Similarly, `fly completion zsh` will provide
  # zsh completions. https://github.com/concourse/concourse/pull/4012
  postInstall = ''
    install -D -m 444 ${./fly.bash} $out/share/bash-completion/completions/fly
  '';

  meta = with lib; {
    description = "A command line interface to Concourse CI";
    homepage = https://concourse-ci.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan ];
  };
}
