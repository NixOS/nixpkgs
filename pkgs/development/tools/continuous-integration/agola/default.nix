{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  version = "0.7.0";
in

buildGoModule {
  pname = "agola";
  inherit version;

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
    sha256 = "sha256-AiD7mVogWk/TOYy7Ed1aT31h1kbrRwseue5qc3wLOCI=";
  };

  vendorSha256 = "sha256-Y3ck7Qdo9uq3YuLzZUe+RZkKQqWpSko3q+f4bfkSz6g=";

  ldflags = [
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
