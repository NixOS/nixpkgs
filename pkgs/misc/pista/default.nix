{ lib, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "pista";
  version = "e426ee675844c90bea285b4bc8ec9a2cc5c3b4ef";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = version;
    sha256 = "sha256-pGK5OWw6u1zx0Qm1n1azm5lDraQEy5ULJca5ZA5eIs8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cargoSha256 = "sha256-8MVUy5QBhELDb4UXGFEPU+yXTjXU4s9cc3x6BHG0AGA=";

  meta = with lib; {
    description = "a simple {bash, zsh} prompt for programmers";
    homepage = "https://github.com/nerdypepper/pista";
    changelog = "https://github.com/nerdypepper/pista/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ benjajaja ];
  };
}
