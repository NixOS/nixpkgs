{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-v4qyVaeqSSG9cmkSGeweZIVv3Dgk/mHHvUpA0Cbio3c=";
  };

  vendorHash = "sha256-UJsncAKtjgF0dn7xAJQdKD8YEIwtFcpYJVWG9b66KRU=";

  meta = with lib; {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
