{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-bM+z3s7oG0+8P7TVmyw7NW3eavN109zgsw9exUSQCaQ=";
  };

  cargoSha256 = "sha256-GxQxyUyrDKTf+7cye0Ob/le06GnAI+FMGCUB5dts+k0=";

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };

  passthru.tests = {
    version = testVersion { package = alejandra; };
  };
}
