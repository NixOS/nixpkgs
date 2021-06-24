{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.2.3";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "17li8jbw3cpn59kpcl3j3r2an4wkx3fc81xn0j4xgbjpkxh9493n";
  };

  vendorSha256 = "081p008sb3lkc8j6sa6n42qi04za4a631kihrd4ca6aigwkgl3ak";

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
