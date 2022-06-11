{ lib
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "ineffassign";
  version = "unstable-2021-09-04";
  rev = "4cc7213b9bc8b868b2990c372f6fa057fa88b91c";

  src = fetchFromGitHub {
    owner = "gordonklaus";
    repo = "ineffassign";
    inherit rev;
    sha256 = "sha256-XLXANN9TOmrNOixWtlqnIC27u+0TW2P3s9MyeyVUcAQ=";
  };

  vendorSha256 = "sha256-QTgWicN2m2ughtLsEBMaQWfpDbmbL0nS5qaIKF3mTJM=";

  allowGoReference = true;

  checkInputs = [ go ];

  meta = with lib; {
    description = "Detect ineffectual assignments in Go code";
    homepage = "https://github.com/gordonklaus/ineffassign";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
