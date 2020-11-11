{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.11458";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "028qm25vhqp2a1jpvy4csgzqy5ijmsnzyh9696x660glrk5q2r1i";
  };

  vendorSha256 = "15l9f87vgspdsxhwqdm56z3dvrspc8k1bbyvhhhnvqf3fkiki2bw";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/CircleCI-Public/circleci-cli/version.Version=${version} -X github.com/CircleCI-Public/circleci-cli/version.Commit=${src.rev} -X github.com/CircleCI-Public/circleci-cli/version.packageManager=nix" ];

  preBuild = ''
    substituteInPlace data/data.go \
      --replace 'packr.New("circleci-cli-box", "../_data")' 'packr.New("circleci-cli-box", "${placeholder "out"}/share/circleci-cli")'
  '';

  postInstall = ''
    install -Dm644 -t $out/share/circleci-cli _data/data.yml
  '';

  meta = with stdenv.lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    license = licenses.mit;
    homepage = "https://circleci.com/";
  };
}
