{ lib, fetchFromGitHub }:
let
  version = "0.15.8";
  srcHash = "sha256-7CTRx7I47VEKfPvkWhmpyHV3hkeLyHymFMrkyYQ1wl8=";
  yarnHash = "sha256-PY0BIBbjyi2DG+n5x/IPc0AwrFSwII4huMDU+FeZ/Sc=";
in
{
  inherit version yarnHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
    hash = srcHash;
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
