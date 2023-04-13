{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
, protobuf
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-USGmYLBv2ynnLx5jg+WkRle0AMtO7dDgf41VIepoHN0=";
  };

  cargoHash = "sha256-zj1eE7f4/wSVe+78abMePqsIrCPl6Uhtavn8hq7+ZRY=";

  nativeBuildInputs = [ installShellFiles mandown protobuf ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
