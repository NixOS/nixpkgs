{ lib, fetchFromGitHub }:
let
  version = "2.0.0";
  srcHash = "sha256-nq8XUZB68WpIKrz4eluJQ96ujGVRvb980QF3CHjO4iA=";
  vendorHash = "sha256-Nt+5X1cbgoqDiZhHu7I3Ws9GpYys41BVZtAYvDfTlbk=";
  yarnHash = "sha256-U/JGqXLn6yrdwhO5YontEchTXnuNp9NkTC8qLpzMDu8=";
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
    "-X go.woodpecker-ci.org/woodpecker/version.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick adamcstephens ];
  };
}
