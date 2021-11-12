{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2021.1.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-Vj5C+PIzZUSD16U4KFO3jR/Gq11P8v3my5eODWb//4c=";
  };

  vendorSha256 = "sha256-EjCOMdeJ0whp2pHZvm4VV2K78UNKzl98Z/cQvGhWSyY=";

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
