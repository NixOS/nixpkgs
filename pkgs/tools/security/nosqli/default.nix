{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "nosqli";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "Charlie-belmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CgD9b5eHDK/8QhQmrqT09Jf9snn9WItNMtTNbJFT2sI=";
  };

  vendorSha256 = "sha256-QnrzEei4Pt4C0vCJu4YN28lWWAqEikmNLrqshd3knx4=";

  meta = with lib; {
    description = "NoSql Injection tool for finding vulnerable websites using MongoDB";
    homepage = "https://github.com/Charlie-belmer/nosqli";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
