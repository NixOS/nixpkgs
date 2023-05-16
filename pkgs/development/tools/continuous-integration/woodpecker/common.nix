{ lib, fetchFromGitHub }:
let
<<<<<<< HEAD
  version = "1.0.2";
  srcHash = "sha256-OeOKR9lTGXU2qumyXq3s/CI56IX4XiI/ZTRHNoY6MEI=";
  vendorHash = "sha256-+2wQKNyCb9xtB1TeE1/oSMEvKoXVX9ARZxsNqE2rfrg=";
  yarnHash = "sha256-QNeQwWU36A05zaARWmqEOhfyZRW68OgF4wTonQLYQfs=";
in
{
  inherit version yarnHash vendorHash;
=======
  version = "0.15.8";
  srcSha256 = "sha256-7CTRx7I47VEKfPvkWhmpyHV3hkeLyHymFMrkyYQ1wl8=";
  yarnSha256 = "sha256-PY0BIBbjyi2DG+n5x/IPc0AwrFSwII4huMDU+FeZ/Sc=";
in
{
  inherit version yarnSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
<<<<<<< HEAD
    hash = srcHash;
  };

  postInstall = ''
    cd $out/bin
=======
    sha256 = srcSha256;
  };

  postBuild = ''
    cd $GOPATH/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick adamcstephens ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
