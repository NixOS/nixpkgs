{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1gSuKxNpls7B+pSGnGj3k/E93lnj2FPNtAAciPPNAeM=";
  };

  vendorSha256 = "sha256-gHZj8zpc7yFthCCBM8WGw4WwoW46bdQWe4yWjOkkQE8=";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
