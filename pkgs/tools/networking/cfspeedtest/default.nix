{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uQe9apG4SdFEUT2aOrzF2C8bbrl0fOiqnMZrWDQvbxk=";
  };

  cargoSha256 = "sha256-wJmLUPXGSg90R92iW9R02r3E3e7XU1gJwd8IqIC+QMA=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
  };
}
