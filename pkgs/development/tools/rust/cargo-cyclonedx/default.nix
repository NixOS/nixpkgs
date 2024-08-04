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
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-rust-cargo";
    rev = "${pname}-${version}";
    hash = "sha256-H/CFEz1+rFHiTEP8JBFH9W9OTHjRdIBOov9c0JO69xE=";
  };

  cargoHash = "sha256-OhkC8R/+mdjFI6WRisFYZk5PKxje3W9X5p9tGCgKQOw=";

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
    mainProgram = "cargo-cyclonedx";
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
