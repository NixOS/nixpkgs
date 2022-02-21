{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-IQ+hv/R6uRPEPr7+SRXyYol4/cQo1ZqcqJxy26CpOoY=";
  };

  cargoSha256 = "sha256-PIqdjtqbSVQoxLj5jGSbrzRQ3qddZvp1Y7tIuFs7UEg=";

  passthru.tests = {
    version = testVersion { package = alejandra; };
  };

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}
