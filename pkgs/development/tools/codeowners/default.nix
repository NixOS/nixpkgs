{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "codeowners";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YhGBg7CP5usSyP3ksX3/54M9gCokK2No/fYANUTdJw0=";
  };

  vendorSha256 = "sha256-no1x+g5MThhWw4eTfP33zoY8TyUtkt60FKsV2hTnYUU=";

  meta = with lib; {
    description = "A CLI and Go library for Github's CODEOWNERS file";
    homepage = "https://github.com/hmarr/codeowners";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp ];
  };
}
