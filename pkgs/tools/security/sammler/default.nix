{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sammler";
  version = "20210523-${lib.strings.substring 0 7 rev}";
  rev = "259b9fc6155f40758e5fa480683467c35df746e7";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "Sammler";
    inherit rev;
    sha256 = "1gsv83sbqc9prkigbjvkhh547w12l3ynbajpnbqyf8sz4bd1nj5c";
  };

  vendorSha256 = "sha256-0ZBPLONUZyazZ22oLO097hdX5xuHx2G6rZCAsCwqq4s=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Tool to extract useful data from documents";
    homepage = "https://github.com/redcode-labs/Sammler";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
  };
}
