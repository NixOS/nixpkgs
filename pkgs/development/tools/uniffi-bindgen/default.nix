{ lib
, rustPlatform
, fetchCrate
, makeWrapper
, ktlint
, yapf
, rubocop
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "uniffi-bindgen";
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-E0OMMg9GuZCwPuJKzMpN0PNxZicGW1blD322Jl01qQE=";
  };

  cargoSha256 = "sha256-REY88irDm45JOBwdb79JVrIyfuOB6HcAgIzYO65O0uE=";

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [
    # this test assumes it is run from the repository
    "--skip=test::test_guessing_of_crate_root_directory_from_udl_file"
  ];

  postFixup = ''
    wrapProgram "$out/bin/uniffi-bindgen" \
      --suffix PATH : ${lib.strings.makeBinPath [ ktlint yapf rubocop rustfmt ] }
  '';

  meta = with lib; {
    description = "Toolkit for building cross-platform software components in Rust";
    homepage = "https://mozilla.github.io/uniffi-rs/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda vtuan10 ];
  };
}
