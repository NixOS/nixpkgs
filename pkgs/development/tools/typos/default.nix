{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.22.9";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FD9Sn1NwiahrYv99avwC2wtoTlwnqiuE7dCNPsD0+y4=";
  };

  cargoHash = "sha256-NmF2pBru3iCOfl5q3Td9HBxi9VGmilUK3q3JckUeu/o=";

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
  };
}
