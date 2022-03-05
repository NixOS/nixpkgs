{ stdenv, lib, fetchFromGitHub
, rustPlatform, pkg-config, openssl
# darwin dependencies
, Security, CoreFoundation, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-geiger";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-KkOLDSnLneal3m+CrYKKIoeO61rjXEDq4GK3kPwQxj4=";
  };
  cargoSha256 = "sha256-i7xDEzZAN2ubW1Q6MhY+xsb9XiUajNDHLdtDuO5r6jA=";

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];
  nativeBuildInputs = [ pkg-config ];

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  # CFURLSetResourcePropertyForKey is defined in the headers but there's no
  # corresponding implementation in the sources from opensource.apple.com.
  preConfigure = lib.optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="-F${CoreFoundation}/Library/Frameworks $NIX_CFLAGS_COMPILE"
  '';

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
