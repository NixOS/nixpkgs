{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "unstable-2022-09-20";

  src = fetchFromGitHub {
    owner = "JorelAli";
    repo = pname;
    rev = "dc68cb088062bbcc31d72e7c921d7e81666a8754";
    sha256 = "sha256-YRkAHLsEBtEB3sxSF/cng9Ftdt4m/EupB9gKcbNoSN8=";
  };

  cargoSha256 = "sha256-sV/1caeXq/he92cvAajDL7pZJN1XCzf/DDXKnPKU1XQ=";

  meta = with lib; {
    description = "A page table of contents for mdBook";
    homepage = "https://github.com/JorelAli/mdbook-pagetoc";
    license = [ licenses.wtfpl ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
