{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7PcDXqizLFNDYVPyUKSk4Eq3Zl+GUZfhrRSYnXVT4EQ=";
  };

  cargoHash = "sha256-Bcw5f2yLhcm+gh6i2RSVTvZt+xU/PdpaWC3RGVm5tEw=";

  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda zendo ];
    mainProgram = "erd";
  };
}
