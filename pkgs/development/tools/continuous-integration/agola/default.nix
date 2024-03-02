{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  version = "0.8.0";
in

buildGoModule {
  pname = "agola";
  inherit version;

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
    hash = "sha256-nU04MVkUC+m6Ga4qDUH9KrA0zbYmttAicpvdxbaBG0Y=";
  };

  vendorHash = "sha256-k3Sip9CqTGRTWxr3RzZf0jCrm4AfUrpY/wSTmHy+yik=";

  ldflags = [
    "-s"
    "-w"
    "-X agola.io/agola/cmd.Version=${version}"
  ];

  tags = [
    "sqlite_unlock_notify"
  ];

  # somehow the tests get stuck
  doCheck = false;

  meta = with lib; {
    description = "Agola: CI/CD Redefined ";
    homepage = "https://agola.io";
    maintainers = with maintainers; [ happysalada ];
    license = licenses.mit;
  };
}
