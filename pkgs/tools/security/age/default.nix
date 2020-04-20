{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "unstable-2020-03-25";
  goPackagePath = "github.com/FiloSottile/age";
  modSha256 = "00yhn1894ni8bvkqm1vr0rqkky52pkhvdzbi2sqx3czlgb5ibw3h";

  subPackages = [
    "cmd/age"
    "cmd/age-keygen"
  ];

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "f0f8092d60bb96737fa096c29ec6d8adb5810390";
    sha256 = "079kfc8d1pr39hr4qnx48kviyzwg4p8m4pz0bdkypns4aq8ppbfk";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
