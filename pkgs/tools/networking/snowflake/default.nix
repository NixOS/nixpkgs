{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "snowflake";
  version = "2.0.1";

  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/${pname}";
    rev = "v${version}";
    hash = "sha256-ULkqsh0DeFI1GsaVaHGSjoEY38EktvDVC52Sx6cQLOE=";
  };

  vendorSha256 = "D5A19UHL1WEE1ODT80jKT+PJ5CTXPjc9Eg6v2Nfm4aw=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.bsd3;
  };
}
