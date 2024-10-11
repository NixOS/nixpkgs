{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rcodesign";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = "apple-platform-rs";
    rev = "apple-codesign/${version}";
    hash = "sha256-F6Etl3Zbpmh3A/VeCcSXIy3W1WYFg8WUSJBJV/akCxU=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];
  cargoPatches = [
    # Update time to a version that is compatible with Rust 1.80
    ./update-time-rs-in-cargo-lock.patch
  ];

  cargoHash = "sha256-VrexypkCW58asvzXo3wj/Rgi72tiGuchA31BkEZoYpI=";


  cargoBuildFlags = [
    # Only build the binary we want
    "--bin"
    "rcodesign"
  ];

  checkFlags = [
    # Does network IO
    "--skip=ticket_lookup::test::lookup_ticket"
  ];

  meta = with lib; {
    description = "Cross-platform CLI interface to interact with Apple code signing";
    mainProgram = "rcodesign";
    longDescription = ''
      rcodesign provides various commands to interact with Apple signing,
      including signing and notarizing binaries, generating signing
      certificates, and verifying existing signed binaries.

      For more information, refer to the [documentation](https://gregoryszorc.com/docs/apple-codesign/stable/apple_codesign_rcodesign.html).
    '';
    homepage = "https://github.com/indygreg/apple-platform-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ euank ];
  };
}
