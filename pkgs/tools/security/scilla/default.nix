{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "scilla";
    rev = "refs/tags/v${version}";
    hash = "sha256-ms52ii2cbZSZtcyxhVN+FbGP6hysoLvS7XwdPqxYymU=";
  };

  vendorHash = "sha256-tOg4T9yQm1aj5G89lUeRUTxi4YrwpRi5KDcpWw4TimY=";

  ldflags = [
    "-w"
    "-s"
  ];

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    mainProgram = "scilla";
    homepage = "https://github.com/edoardottt/scilla";
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
