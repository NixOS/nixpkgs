{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "135zz5gp5vqqwmz3701n5xfvz9yxzm4m53q3dbj9vfc8xkcxn44n";
  };

  modSha256 = "0jirpfd427317px0fd630bmi3li6zc5vihydwmwbj0qsfvhn4qm4";
  subPackages = [ "cmd/lego" ];

  buildFlagsArray = [
    "-ldflags=-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
