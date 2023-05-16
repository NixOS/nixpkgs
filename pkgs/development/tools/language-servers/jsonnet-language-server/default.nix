{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-4tJrEipVbiYQY0L9sDH0f/qT8WY7c3md/Bar/dST+VI=";
  };

  vendorHash = "sha256-/mfwBHaouYN8JIxPz720/7MlMVh+5EEB+ocnYe4B020=";
=======
    hash = "sha256-jmeXX4l0A6bVRt9eJI6wDzjOcjPC0/uElT/2YwhWoqw=";
  };

  vendorHash = "sha256-lC3GAOJ/XVzn+9kk4PnW/7UwqjiXP7DqYmqauwOqQ+k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${version}'"
  ];

  meta = with lib; {
    description = "Language Server Protocol server for Jsonnet";
    homepage = "https://github.com/grafana/jsonnet-language-server";
    changelog = "https://github.com/grafana/jsonnet-language-server/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ hardselius ];
  };
}
