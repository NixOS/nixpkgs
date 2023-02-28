{ lib
, stdenv
, fetchFromGitHub
, libiconv
, rustPlatform
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dz7Mxi5KIZYw0oLic50hNT6rWbQpfiBE4hlZsxNfKsA=";
  };

  cargoHash = "sha256-I9pd+Q3b++ujynfpZq88lqPSUOc/SXWpNzR/CwtNEPA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    libiconv
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins msfjarvis ];
  };
}
