{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VTX4NG3BzmLpf2sIxZ5DGjg9dnCTSO0VbGx2PMhjBPg=";
  };

  vendorSha256 = "sha256-aoz2H7hkk85ntao6e5Chn++T2kA5jogHrd/ltVqNS3A=";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
