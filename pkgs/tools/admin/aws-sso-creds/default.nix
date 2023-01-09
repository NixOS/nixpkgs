{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-creds";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iyTdVvbqewLPLJB0LjeMB0HvLTi4B3B/HDCvgSlZoNE=";
  };
  vendorSha256 = "sha256-SIsM3S9i5YKj8DvE90DxxinqZkav+1gIha1xZiDBuHQ=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso-creds \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/jaxxstorm/aws-sso-creds";
    description = "Get AWS SSO temporary creds from an SSO profile";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
    mainProgram = "aws-sso-creds";
  };
}
