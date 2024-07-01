{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  version = "0.9.2";
in

buildGoModule {
  pname = "agola";
  inherit version;

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
    hash = "sha256-ggi0Eb4vO5zBoIrIIa3MFwOIW0IBS8yGF6eveBb+lgY=";
  };

  vendorHash = "sha256-Igtccundx/2PHFp8+L44CvOLG+/Ndinhonh/EDcQeoY=";

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
