{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "codeowners";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bjSlt439Y5hmbxR6s4J37ao+P2tuKNuwqRg872P+MUg=";
  };

  vendorHash = "sha256-G+oaX3SXsHJu3lq6n8dLmoRXDAYcFkrYarwePB/MdEU=";

  meta = with lib; {
    description = "A CLI and Go library for Github's CODEOWNERS file";
    mainProgram = "codeowners";
    homepage = "https://github.com/hmarr/codeowners";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp ];
  };
}
