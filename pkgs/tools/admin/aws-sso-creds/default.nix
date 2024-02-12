{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-creds";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/zvXVDVlnDcgYpnumN7owN2fHexvQu5D4LvNmuQNS+w=";
  };
  vendorHash = "sha256-mJj5ilH4crlL5jesvg0y3RZaMgqlrenWgJApxUw6jEk=";

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
