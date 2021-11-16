{ lib
, stdenv
, fetchFromGitHub
, libiconv
, rustPlatform
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d5an35fnz9rdr2ssm952zpzn4jynpvbfyidnqcmp0lclr60c2ir";
  };

  cargoSha256 = "sha256-CtQ4grQqgMUYzPDw2Qankl8jmqwwCrawNCmaY97JPkQ=";

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
