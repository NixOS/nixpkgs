{ buildGoModule, fetchFromGitHub, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "1jhc2h00rh6lpgdq3n2d1sk7gdzmhkigyra04gf70s6kjb903igw";
  };

  modSha256 = "00qagz28iz1z5kjshs1m74bf12qlhjbkf4pbchy7lzf09bd291pg";

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
