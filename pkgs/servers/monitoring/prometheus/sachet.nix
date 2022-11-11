{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sachet";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = pname;
    rev = version;
    sha256 = "sha256-zcFViE1/B+wrkxZ3YIyfy2IBbxLvXOf8iK/6eqZb1ZQ=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "An SMS alerting tool for Prometheus's Alertmanager";
    homepage = "https://github.com/messagebird/sachet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ govanify ];
  };
}
