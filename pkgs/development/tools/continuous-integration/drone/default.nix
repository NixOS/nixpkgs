{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.6.0";
  goPackagePath = "github.com/drone/drone";

  modSha256 = "0l33qib9riknrjdpsvd7n6slqp485vx66xl6w7m24b5sc7yfsg7m";

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "0ij4a6rh17ib360bxrpncf8lp839b6sl17bd0fp3xvwmibk6xgjz";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = licenses.asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
