{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.7179";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "0md6y2rnzhkpxc2pm3c46jrhwicrswy9qlr6a4mmvpjq1imj1hjq";
  };

  modSha256 = "169d0mm52l6w6jln5ak6zkh97q65m9jpg3bm8qll6sfrmrnfncfi";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/CircleCI-Public/circleci-cli/version.Version=${version}" ];

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
