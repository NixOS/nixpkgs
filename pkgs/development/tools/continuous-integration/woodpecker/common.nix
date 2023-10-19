{ lib, fetchFromGitHub }:
let
  version = "1.0.3";
  srcHash = "sha256-P1ODGxHkrh8o+RMxxu7OCuHkShfLyQcF9KVNYw45T5A=";
  vendorHash = "sha256-j2C66oTv0RY8VGDEivrj/p2PtGAhrDhi9oBvNXATurI=";
  yarnHash = "sha256-TrcTc5svLLSedRC8gCwIBW7/mtHo+uSNZGImtRiVJ0w=";
in
{
  inherit version yarnHash vendorHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
    hash = srcHash;
  };

  postInstall = ''
    cd $out/bin
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
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick adamcstephens ];
  };
}
