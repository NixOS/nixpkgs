{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x8cfLn8b9h6+rpAVXZHdaVTzkzlDSfyGWveDX9usIPE=";
  };

  cargoHash = "sha256-eGA3oTDk3tGzYDeGJwe6+Tpum+ue534qXv79SotDy/o=";

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
