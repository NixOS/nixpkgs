{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.6.5";
  goPackagePath = "github.com/drone/drone";

  vendorSha256 = "1dvf8vz3jr9smki3jql0kvd8z8rwdq93y7blbr2yjjfsdvx6lxl1";

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "05cgd72qyss836fby0adhrm5p8g7639psk2yslhg6pmz0cqfbq9m";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}