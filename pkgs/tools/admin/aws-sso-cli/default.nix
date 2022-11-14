{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-voCFr5rb9VBSG926SeE2cMuk1gJskoaqjvkRY/9TZFU=";
  };
  vendorSha256 = "sha256-f0HrQzHK1JDWmRrnqG/N4X8TG0DP/IRWd6b7QR/vyzo=";

  nativeBuildInputs = [ makeWrapper ];

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
