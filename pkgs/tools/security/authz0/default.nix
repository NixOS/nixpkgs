{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "authz0";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NrArxuhzd57NIdM4d9p/wfCB1e6l83pV+cjjCgZ9YtM=";
  };

  vendorHash = "sha256-ARPrArvCgxLdCaiUdJyjB/9GbbldnMXwFbyYubbsqxc=";

  meta = with lib; {
    description = "Automated authorization test tool";
    mainProgram = "authz0";
    homepage = "https://github.com/hahwul/authz0";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
