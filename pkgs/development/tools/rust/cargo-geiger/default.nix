{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
  # darwin dependencies
, Security
, CoreFoundation
, libiconv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-xymDV/FHJABw1s94m8fl8D51PQwkF5dX+1XD96++RX8=";
  };
  cargoSha256 = "sha256-2szgR9N3PGjGCIjqgtGNFSnzfSv57sGfslZ/PZyqMjI=";

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security libiconv curl ];
  nativeBuildInputs = [ pkg-config ]
    # curl-sys wants to run curl-config on darwin
    ++ lib.optionals stdenv.isDarwin [ curl.dev ];

  # skip tests with networking or other failures
  checkFlags = [
    "--skip serialize_test2_quick_report"
    "--skip serialize_test3_quick_report"
    "--skip serialize_test6_quick_report"
    "--skip serialize_test2_report"
    "--skip serialize_test3_report"
    "--skip serialize_test6_report"
    "--skip test_package::case_2"
    "--skip test_package::case_3"
    "--skip test_package::case_6"
    "--skip test_package_update_readme::case_2"
    "--skip test_package_update_readme::case_3"
    "--skip test_package_update_readme::case_5"
  ];

  meta = with lib; {
    homepage = "https://github.com/rust-secure-code/cargo-geiger";
    changelog = "https://github.com/rust-secure-code/cargo-geiger/blob/${pname}-${version}/CHANGELOG.md";
    description = "Detects usage of unsafe Rust in a Rust crate and its dependencies";
    longDescription = ''
      A cargo plugin that detects the usage of unsafe Rust in a Rust crate and
      its dependencies. It provides information to aid auditing and guide
      dependency selection but it can not help you decide when and why unsafe
      code is appropriate.
    '';
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ evanjs jk ];
  };
}
