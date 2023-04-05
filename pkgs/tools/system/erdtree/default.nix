{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dSIq6PNkFkdYvAzNQ1qBEZWEdiYYZCb/7rNICuUJAsE=";
  };

  cargoHash = "sha256-Dpg4AbDClqh6yzI/s5LQDP6QkyTMLP/IJIp2l2d+Ouw=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "et";
  };
}
