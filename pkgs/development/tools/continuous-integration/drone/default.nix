{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.9.0";
  goPackagePath = "github.com/drone/drone";

  vendorSha256 = "0idf11sr417lxcjryplgb87affr6lgzxazzlyvk0y40hp8zbhwsx";

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "1lsyd245fr1f74rpccvvw41h5g75b79afrb8g589bj13ggjav0xy";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
