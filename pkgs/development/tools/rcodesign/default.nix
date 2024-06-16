{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rcodesign";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = "apple-platform-rs";
    rev = "apple-codesign/${version}";
    hash = "sha256-ndbDBGtTOfHHUquKrETe4a+hB5Za9samlnXwVGVvWy4=";
  };

  cargoHash = "sha256-cpQBdxTw/ge4VtzjdL2a2xgSeCT22fMIjuKu5UEedhI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];

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
    description = "A cross-platform CLI interface to interact with Apple code signing";
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
