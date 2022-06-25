{ lib
, buildGoModule
, fetchFromGitHub
, gosca
, testers
}:

buildGoModule rec {
  pname = "gosca";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "TARI0510";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mjQSYkcLl9X3IPv0liX26hvystsQOSVXvovKp4VekAY=";
  };

  vendorSha256 = "sha256-0EqMW4aNYPZEuk+mxmLTuenGdam56YneEad8lodVeBo=";

  passthru.tests.version = testers.testVersion {
    package = gosca;
    command = "gosca -v";
    version = "GoSCA_v${version}";
  };

  meta = with lib; {
    description = "Golang dependence security checker";
    homepage = "https://github.com/TARI0510/gosca";
    changelog = "https://github.com/TARI0510/gosca/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
