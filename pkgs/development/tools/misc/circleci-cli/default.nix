{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "circleci-cli";
  version = "0.1.6072";

  src = fetchFromGitHub {
    owner = "CircleCI-Public";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sbzl6y7974sib14qr2qa6d20cs54h6a3mc1whbxifg87cw02qjn";
  };

  modSha256 = "1pxqc2a1hb6bk67sd2c37zwg6n7h0jay3yqsjcs4jc0bqv48gzip";

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
    homepage = https://circleci.com/;
  };
}
