{ lib, fetchFromGitHub }:
let
  version = "1.0.5";
  srcHash = "sha256-tkgkhYuLHfmT42P+UMZ7uNB2wBKo0YGiw0a5RoMAu6M=";
  vendorHash = "sha256-QTTnTPOgP+FlbqXNCGJc9VuBzQcMujpvFB3+DykYTPY=";
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
