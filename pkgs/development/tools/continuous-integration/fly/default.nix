{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "09cfsq8vfjhavhqcydg0l3bi1g12y2p160yi2v0y5vk7ipiqyzrd";
  };

  vendorSha256 = "1fxbxkg7disndlmb065abnfn7sn79qclkcbizmrq49f064w1ijr4";

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
