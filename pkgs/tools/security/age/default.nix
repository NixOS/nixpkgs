{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-beta5";
  vendorSha256 = "0km7a2826j3fk2nrkmgc990chrkcfz006wfw14yilsa4p2hmfl7m";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "1hdbxd359z8zvnz7h8c4pa16nc7r8db36lx3gpks38lpi0r8hzqk";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
