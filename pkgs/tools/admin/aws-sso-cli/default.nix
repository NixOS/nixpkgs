{ buildGoModule
, fetchFromGitHub
, getent
, lib
, makeWrapper
, stdenv
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jFeF/nxJMUO0tH8kgLgV6DIvN9KbcTy19LEvu4Paq8M=";
  };
  vendorHash = "sha256-0ji2i2MSEqd3xxos96FHn9srDOtpvX3mFlaNoiTEa/U=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Tag=nixpkgs"
  ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  nativeCheckInputs = [ getent ];

  checkFlags = [
    "-skip=TestAWSConsoleUrl|TestAWSFederatedUrl"
  ] ++ lib.optionals stdenv.isDarwin [ "--skip=TestDetectShellBash" ];

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
