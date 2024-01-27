{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-creds";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V50t1L4+LZnMaET3LTp1nt7frNpu95KjgbQ5Onqt5sI=";
  };
  vendorHash = "sha256-0jXZpdiSHMn94MT3mPNtbfV7owluWhy1iAvQIBdebdE=";

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
