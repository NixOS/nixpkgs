{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-beta4";
  goPackagePath = "github.com/FiloSottile/age";
  vendorSha256 = "0km7a2826j3fk2nrkmgc990chrkcfz006wfw14yilsa4p2hmfl7m";

  subPackages = [
    "cmd/age"
    "cmd/age-keygen"
  ];

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "0pp6zn4rdypyxn1md9ppisiwiapkfkbh08rzfl3qwn0998wx6gnb";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
