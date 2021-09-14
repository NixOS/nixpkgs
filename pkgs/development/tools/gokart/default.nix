{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gokart";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wfv33yi83klnnyfas7wnsnx34cf28k1yvq06lkii96fvnzcar36";
  };

  vendorSha256 = "0l5aj7j9m412bgm9n553m2sh9fy9dpzd0bi3qn21gj7bfdcpagnd";

  # Would need files to scan which are not shipped by the project
  doCheck = false;

  meta = with lib; {
    description = "Static analysis tool for securing Go code";
    homepage = "https://github.com/praetorian-inc/gokart";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
