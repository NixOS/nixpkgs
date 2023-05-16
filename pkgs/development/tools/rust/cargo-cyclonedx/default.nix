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
<<<<<<< HEAD
  version = "0.3.8";
=======
  version = "0.3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-rust-cargo";
    rev = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-6XW8aCXepbVnTubbM4sfRIC87uYSCEbuj+jJcPayEEU=";
  };

  cargoHash = "sha256-BG/vfa5L6Iibfon3A5TP8/K8jbJsWqc+axdvIXc7GmM=";
=======
    hash = "sha256-xr3YNjQp+XhIWIqJ1rPUyM9mbtWGExlFEj28/SB8vfE=";
  };

  cargoHash = "sha256-NsBY+wb4IAlKOMh5BMvT734z//Wp/s0zimm04v8pqyc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
