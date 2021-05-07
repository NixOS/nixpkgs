{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.2.0";

  cargoSha256 = "sha256-aEwMJ9f08SJhrL8kLaTp54yP1hYGb3Ob5KNzZ5r752s=";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3M6wQB7+1MKPcxSvjDTNs33TrFjCEeFlbh1akwJHLLU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = with lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
