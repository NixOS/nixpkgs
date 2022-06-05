{ lib
, stdenv
, fetchFromGitHub
, libiconv
, rustPlatform
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7MNVLfBH6hWoNy+UQzK6gwZuPbBPMfG660my+E6FT5Q=";
  };

  cargoSha256 = "sha256-8Ur3KwGuIY8QAGNTcyTpFg2C1CBcIpZJp6EO9g8XuE8=";

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
