{ lib
, buildGoModule
, fetchFromGitHub
}:

let
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

buildGoModule {
  pname = "agola";
  inherit version;

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nU04MVkUC+m6Ga4qDUH9KrA0zbYmttAicpvdxbaBG0Y=";
  };

  vendorHash = "sha256-k3Sip9CqTGRTWxr3RzZf0jCrm4AfUrpY/wSTmHy+yik=";

  ldflags = [
    "-s"
=======
    sha256 = "sha256-AiD7mVogWk/TOYy7Ed1aT31h1kbrRwseue5qc3wLOCI=";
  };

  vendorSha256 = "sha256-Y3ck7Qdo9uq3YuLzZUe+RZkKQqWpSko3q+f4bfkSz6g=";

  ldflags = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
