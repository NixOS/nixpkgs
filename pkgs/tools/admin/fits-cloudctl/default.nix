{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.12.18";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    hash = "sha256-ScHdYSDZVs9YYIh1/U/8ZcGa9BF5L+fIHnSHWSRlB4k=";
  };

  vendorHash = "sha256-7vIcfxDmO8tmVewRDx6JhOgtkKeHOk0qyFZf1U0VQs4=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
