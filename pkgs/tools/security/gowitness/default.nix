{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gowitness";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    sha256 = "sha256-rylft6v6Np8xOm2AUtH7e/zDZQ87WNPeerXEtziSrDw=";
  };

  vendorHash = "sha256-l6jdVsKKLqEyFpz7JhkLLjVTWX1pZenlCY5UqSZVMdc=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
