{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
  # darwin dependencies
, darwin
, libiconv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-rGZJyCWGk2RUr52ICp4dVER3JMBrnLdOMusRm/GG2PE=";
  };
  cargoHash = "sha256-B6Ka35y2fJEDVd891P60TNppr5HGFnzVjLhhfoFCYUA=";

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation Security libiconv curl ]);
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
    # multiple test cases that time-out or cause memory leaks
    "--skip test_package"
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
