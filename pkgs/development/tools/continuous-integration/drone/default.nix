{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "drone.io-${version}";
  version = "1.6.5";
  goPackagePath = "github.com/drone/drone";

  modSha256 = "1fyb9218s52w8c6c3v6rgivbyzy5hz4q4z8r75ng2yrmjmmiv2gr";

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
