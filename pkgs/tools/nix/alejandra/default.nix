{ lib
, rustPlatform
, fetchFromGitHub
, testVersion
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-WgVEI+io05sUIMxdsYOWOJOVNeTDpDiDeTTbxoDFHZU=";
  };

  cargoSha256 = "sha256-AO/LTW9ogDRPns2uPXOvkXJUfeeI+beT7qUGi8IHiwk=";

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
