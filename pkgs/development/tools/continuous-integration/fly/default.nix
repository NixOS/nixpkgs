{ buildGoModule, fetchFromGitHub, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "0ji3jya4b2b4l6dlvydh3k2jfh6kkhii23d6rmi49ypydhn1qmgj";
  };

  modSha256 = "14wwspp8x6i4ry23bz8b08mfyzrwc9m7clrylxzr8j67yhg5kw6v";

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
    homepage = "https://concourse-ci.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivanbrennan ];
  };
}
