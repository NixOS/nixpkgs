{ lib
, rustPlatform
, fetchCrate
, makeWrapper
, ktlint
, yapf
, rubocop
, rustfmt
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "uniffi-bindgen";
  version = "0.22.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-cUJsfAlzdoGMeFcdXwdPU0JcruneY60pssJPkJtb5gs=";
  };

  cargoSha256 = "sha256-k5uIR5rO4T1Xsu50vdLxCgSsVkNcxXHT4MitnMZkY6g=";

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [
    # this test assumes it is run from the repository
    "--skip=test::test_guessing_of_crate_root_directory_from_udl_file"
  ];

  postFixup = ''
    wrapProgram "$out/bin/uniffi-bindgen" \
      --suffix PATH : ${lib.strings.makeBinPath [ ktlint yapf rubocop rustfmt ] }
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Toolkit for building cross-platform software components in Rust";
    homepage = "https://mozilla.github.io/uniffi-rs/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda vtuan10 ];
  };
}
