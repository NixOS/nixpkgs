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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EuhnI7N8Ry6qV4q3QxdHdTuJ7F4gIA3a9NZnb33KWZ8=";
  };

  cargoHash = "sha256-2FEtYnIRg4s92K8Kr123tuZqUsGOauel2JdeSF0bFGo=";

  nativeBuildInputs = [ installShellFiles mandown protobuf ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
