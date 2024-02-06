{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sGBEVmiVa9jWlirtmP+lhXNVN2X9Pv/oS9KhiuaOMl8=";
  };

  cargoHash = "sha256-/Ajlo6nr36GF5jyyuKdQe5HajETMsuEWbXxaszrcj0Y=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
  };
}
