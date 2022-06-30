{ lib
, stdenv
, fetchFromGitHub
, libiconv
, rustPlatform
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GimCHMUUjD1q5CfKXKtucIs/HLIJZnIbp+wtN+/jjhY=";
  };

  cargoSha256 = "sha256-/qSaPvI4K9AinewMlsCp2funJrZtwvoBUQ6816NQ8zw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    libiconv
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins msfjarvis ];
  };
}
