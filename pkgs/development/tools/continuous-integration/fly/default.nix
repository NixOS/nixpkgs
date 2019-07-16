{ buildGoModule, fetchFromGitHub, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "06ns98k47nafhkkj7gkmxp7msn4ssypyss6ll0fm6380vq2cavnj";
  };

  modSha256 = "11rnlmn5hp9nsgkmd716dsjmkr273035j9gzfhjxjsfpiax60i0a";

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
