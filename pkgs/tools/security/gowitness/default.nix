{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gowitness";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    sha256 = "sha256-e4J+W5VHVy/ngC5FDsDBStIaIR7jODWPt8VGTfAse44=";
  };

  vendorSha256 = "sha256-NFQbulW07sljskjLn6A4f+PMMCJxploYqAHE+K7XxH8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
