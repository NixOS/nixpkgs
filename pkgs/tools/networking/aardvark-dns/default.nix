{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MejXcHleJ6AmnoiZefZfp9La8D4PxHgEg0pMxUk2740=";
  };

  cargoHash = "sha256-r7etdWr/0cY38A7fRB5QQ86EyQ5YpuxyY3vx5qrdquc=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "aardvark-dns";
  };
}
