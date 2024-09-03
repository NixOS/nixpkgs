{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oQy3R9PSM8jU4qs3clxK0HmmM0Ua4pwZYxnu0d6SW+I=";
  };

  cargoHash = "sha256-z2JN5JyUIEeZInw5qpRf/Zja+7Np9YnBj3hcohFkAsc=";

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
  };
}
