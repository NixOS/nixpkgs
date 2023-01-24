{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "codeowners";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lklKZCDX/e3MZ0ix3A4AIEICPoufBq7SAIULqDXOYDI=";
  };

  vendorSha256 = "sha256-G+oaX3SXsHJu3lq6n8dLmoRXDAYcFkrYarwePB/MdEU=";

  meta = with lib; {
    description = "A CLI and Go library for Github's CODEOWNERS file";
    homepage = "https://github.com/hmarr/codeowners";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp ];
  };
}
