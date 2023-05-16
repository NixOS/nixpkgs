{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
<<<<<<< HEAD
  version = "1.13.1";
=======
  version = "1.9.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QwixApaGUzTmvc9TfFk8bdMU7dxyaeUo5aWucV4tH1c=";
  };
  vendorHash = "sha256-/6DCrjOqjbz+olRp7rs8ui4uUrcor0zAc0yOIz+ZcEo=";
=======
    sha256 = "sha256-hDXCH5B4bc0SKv/qzk92bPm366LmdYWTuVVn8KI0avo=";
  };
  vendorHash = "sha256-myjHRZXTjsLXD8kibcdf1/Nhvx50fDsFtmZd63DpiiI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Tag=nixpkgs"
  ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
