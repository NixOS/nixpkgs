{ lib, fetchFromGitHub }:
let
  version = "0.15.5";
  srcSha256 = "yaA2PKw4xuqd8vGXh/GhcJJHw4mJ1z97tWJTREE14ow=";
  yarnSha256 = "1jpb4gblmknl81f6iclqg8ba82ca931q38xpm0kzki8y5ayk9n67";
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
