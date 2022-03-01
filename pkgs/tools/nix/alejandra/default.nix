{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-jhmNDzNICcXc0p+Esi+uWCL1wOkGDyrJGBa0IEnkE08=";
  };

  cargoSha256 = "sha256-4EtiF2W0J0OeguLDfjJbpHQKUZNtejxbTF1gNiP7SEQ=";

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
