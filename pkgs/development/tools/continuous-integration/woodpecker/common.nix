{ lib, fetchFromGitHub }:
rec {
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
    sha256 = "sha256-HOOH3H2SXLcT2oW/xL80TO+ZSI+Haulnznpb4hlCQow=";
  };

  yarnSha256 = "sha256-x9g0vSoexfknqLejgcNIigmkFnqYsmhcQNTOStcj68o=";

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
    maintainers = with maintainers; [ ambroisie ];
  };
}
