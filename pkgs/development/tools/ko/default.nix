{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "ko";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LoOXZY4uF7GSS3Dh/ozCsLJTxgmPmZZuEisJ4ShjCBc=";
  };

  vendorSha256 = null;
  excludedPackages = "test";
  checkInputs = [ git ];
  preCheck = ''
    git init
  '';

  meta = with lib; {
    description = "A simple, fast container image builder for Go applications.";
    homepage = "https://github.com/google/ko";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
