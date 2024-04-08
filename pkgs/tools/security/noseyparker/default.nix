{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, hyperscan
}:

rustPlatform.buildRustPackage rec {
  pname = "noseyparker";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "noseyparker";
    rev = "v${version}";
    hash = "sha256-qop6KjTFPQ5o1kPEVPP0AfDfr8w/JP3YmC+sb5OUbDY=";
  };

  cargoHash = "sha256-ZtoJO/R11qTFYAE6G7AVCpnYZ3JGrxtVSXvCm0W8DAA=";

  postPatch = ''
    # disabledTests (network, failing)
    rm tests/test_noseyparker_github.rs
    rm tests/test_noseyparker_scan.rs
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    hyperscan
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Find secrets and sensitive information in textual data";
    mainProgram = "noseyparker";
    homepage = "https://github.com/praetorian-inc/noseyparker";
    changelog = "https://github.com/praetorian-inc/noseyparker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F ];
    # limited by hyperscan
    platforms = [ "x86_64-linux" ];
  };
}
