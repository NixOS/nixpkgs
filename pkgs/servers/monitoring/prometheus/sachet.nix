{
  lib,
  buildGoModule,
  fetchFromGitHub,
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

<<<<<<< HEAD
  meta = {
    description = "SMS alerting tool for Prometheus's Alertmanager";
    mainProgram = "sachet";
    homepage = "https://github.com/messagebird/sachet";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ govanify ];
=======
  meta = with lib; {
    description = "SMS alerting tool for Prometheus's Alertmanager";
    mainProgram = "sachet";
    homepage = "https://github.com/messagebird/sachet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ govanify ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
