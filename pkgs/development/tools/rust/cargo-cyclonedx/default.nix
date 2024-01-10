{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, SystemConfiguration
, CoreFoundation
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cyclonedx";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-rust-cargo";
    rev = "${pname}-${version}";
    hash = "sha256-JrusJsMjaWAsWAssU+q87BCH2ouLfthIw47ypwBkR9o=";
  };

  cargoHash = "sha256-QzEojbwBF7s3C+LlFWle0+8DVtyEljuqAcMAyRJqFcs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
    CoreFoundation
    curl
  ];

  meta = with lib; {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects";
    longDescription = ''
      The CycloneDX module for Rust (Cargo) creates a valid CycloneDX Software
      Bill-of-Material (SBOM) containing an aggregate of all project
      dependencies. CycloneDX is a lightweight SBOM specification that is
      easily created, human and machine readable, and simple to parse.
    '';
    homepage = "https://github.com/CycloneDX/cyclonedx-rust-cargo";
    license = licenses.asl20;
    maintainers = with maintainers; [ nikstur ];
  };
}
