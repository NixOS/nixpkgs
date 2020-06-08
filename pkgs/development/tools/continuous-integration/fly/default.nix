{ buildGoModule, fetchFromGitHub, stdenv, lib, writeText }:

buildGoModule rec {
  pname = "fly";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse";
    rev = "v${version}";
    sha256 = "0k7hhzhz6bszxq7qcz7xiz6rk90pyhl9vpd09agmyaapbb9swf99";
  };

  vendorSha256 = "0bpqsd4gbxxm5hkdr7iczxck2w98znsa3fvfacjw869kkzkvr36z";

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
