{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6UP+5niKAdO4DgdEnTdpbUnr2BLKwAgHcEZqkgzCcqs=";
  };
  vendorHash = "sha256-TU5kJ0LIqHcfEQEkk69xWJZk30VD9XwlJ5b83w1mHKk=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Tag=nixpkgs"
  ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  checkFlags = [
    # requires network access
    "-skip=TestAWSConsoleUrl|TestAWSFederatedUrl"
  ];

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
