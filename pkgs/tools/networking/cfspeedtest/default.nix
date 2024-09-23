{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-K/rotb4rgYKOF1Gvgb8uPfHCAyYqwcvyU26ZlKGxHcs=";
  };

  cargoHash = "sha256-clIMlnLXL4ciD1H0LNSLH/ooKIfoZy9D/RDvoSHfG+I=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
