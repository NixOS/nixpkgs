{ buildGoModule, fetchFromGitHub, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "0chavwymyh5kv4fkvdjvf3p5jjx4yn9aavq66333xnsl5pn7q9dq";
  };

  modSha256 = "1wiyfii4rmj3rp8ls0ill0sjpnpjz7l3q5fzrscm8ap1qn90gvzg";

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
