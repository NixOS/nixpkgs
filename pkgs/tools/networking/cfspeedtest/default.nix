{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-55g3dskYlAJNnoLwjTL0XvpDIk2l53EQ+CZ1MzhuxNI=";
  };

  cargoHash = "sha256-lTYiL5kCm9NClN4YjIlHz6aQlEwrESE25lOdJGkLMDA=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    mainProgram = "cfspeedtest";
  };
}
