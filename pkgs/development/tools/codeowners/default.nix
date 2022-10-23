{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "codeowners";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hmarr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4/e+EnRI2YfSx10mU7oOZ3JVE4TNEFwD2YJv+C0qBhI=";
  };

  vendorSha256 = "sha256-UMLM9grPSmx3nAh1/y7YhMWk12/JcT75/LQvjnLfCyE=";

  meta = with lib; {
    description = "A CLI and Go library for Github's CODEOWNERS file";
    homepage = "https://github.com/hmarr/codeowners";
    license = licenses.mit;
    maintainers = with maintainers; [ yorickvp ];
  };
}
