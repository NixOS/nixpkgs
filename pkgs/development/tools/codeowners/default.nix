{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "codeowners";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ttJLJtuZrY71eKcjoSLypGTUeXd2lAJlM10Ft9YEEKc=";
  };

  vendorSha256 = "sha256-UMLM9grPSmx3nAh1/y7YhMWk12/JcT75/LQvjnLfCyE=";

  meta = with lib; {
    description = "A CLI and Go library for Github's CODEOWNERS file";
    homepage = "https://github.com/hmarr/codeowners";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp ];
  };
}
