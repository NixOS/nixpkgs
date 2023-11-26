{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7nuLHhkVwMc2RYq3rS9bZl39asjFAnsHxnecPypT1HM=";
  };

  cargoHash = "sha256-WwM4lPWQmfsBjL4M/j3sZkLtH+Wdy9LTv4M4AF0Z6oo=";

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
