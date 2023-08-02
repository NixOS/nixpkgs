{ lib, fetchFromGitHub }:
let
  version = "1.0.0";
  srcHash = "sha256-1HSSHR3myn1x75kO/70w1p21a7dHwFiC7iAH/KRoYsE=";
  vendorHash = "sha256-UFTK3EK8eYB3/iKxycCIkSHdLsKGnDkYCpoFJSajm5M=";
  yarnHash = "sha256-QNeQwWU36A05zaARWmqEOhfyZRW68OgF4wTonQLYQfs=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick ];
  };
}
