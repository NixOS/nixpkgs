{ lib, fetchFromGitHub }:
let
  version = "0.15.6";
  srcSha256 = "sha256-8XXeGEw7+NGULsD5/g1j9+P2h82oRpEuMJT6sMp+z38=";
  yarnSha256 = "sha256-PY0BIBbjyi2DG+n5x/IPc0AwrFSwII4huMDU+FeZ/Sc=";
in
{
  inherit version yarnSha256;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
    sha256 = srcSha256;
  };

  postBuild = ''
    cd $GOPATH/bin
    for f in *; do
      mv -- "$f" "woodpecker-$f"
    done
    cd -
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/woodpecker-ci/woodpecker/version.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://woodpecker-ci.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick ];
  };
}
