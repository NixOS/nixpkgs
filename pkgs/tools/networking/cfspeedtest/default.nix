{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0BX9nEhSyYY/fDJHZOw0URLPIXZGRGZyXB1Tm8GX1/A=";
  };

  cargoHash = "sha256-GNoYLps6OaA3Ubb0nG6hQfe6r52lhnIb19n1PLCsbXs=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
