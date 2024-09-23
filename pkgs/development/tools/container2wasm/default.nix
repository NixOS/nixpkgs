{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    rev = "refs/tags/v${version}";
    hash = "sha256-PFgaqzl6uc6vHzcZ9+FpugAOFSBKhxAsoSvmYHxUmLs=";
  };

  vendorHash = "sha256-j6oqYpFcfZy4Lz4C9wbJGI2RdJsAxQxBqcLNWgKk/UU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ktock/container2wasm/version.Version=${version}"
  ];

  subPackages = [
    "cmd/c2w"
  ];

  meta = with lib; {
    description = "Container to WASM converter";
    homepage = "https://github.com/ktock/container2wasm";
    changelog = "https://github.com/ktock/container2wasm/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "c2w";
  };
}
