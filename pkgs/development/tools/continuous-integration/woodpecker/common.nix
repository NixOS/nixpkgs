{ lib, fetchFromGitHub }:
let
  version = "1.0.2";
  srcHash = "sha256-OeOKR9lTGXU2qumyXq3s/CI56IX4XiI/ZTRHNoY6MEI=";
  vendorHash = "sha256-+2wQKNyCb9xtB1TeE1/oSMEvKoXVX9ARZxsNqE2rfrg=";
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
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick adamcstephens ];
  };
}
