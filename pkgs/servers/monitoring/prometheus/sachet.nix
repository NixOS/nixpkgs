{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sachet";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = pname;
    rev = version;
    hash = "sha256-zcFViE1/B+wrkxZ3YIyfy2IBbxLvXOf8iK/6eqZb1ZQ=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "SMS alerting tool for Prometheus's Alertmanager";
    mainProgram = "sachet";
    homepage = "https://github.com/messagebird/sachet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ govanify ];
  };
}
