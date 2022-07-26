{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    sha256 = "9/dZfRmFAyE5NEMmuiVsRvwgqQrTNhXkTR9N0d3zgfk=";
  };
  vendorSha256 = "BlSCLvlrKiubMtfFSZ5ppMmL2ZhJcBXxJfeRgMADYB4=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/aws-sso
    wrapProgram $out/bin/aws-sso \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
