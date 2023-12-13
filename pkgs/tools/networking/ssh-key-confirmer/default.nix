{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-key-confirmer";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "benjojo";
    repo = "ssh-key-confirmer";
    rev = "v${version}";
    hash = "sha256-CXDjm8PMdCTwHnZWa0fYKel7Rmxq0XBWkfLmoVuSkKM=";
  };

  vendorHash = "sha256-CkfZ9dImjdka98eu4xuWZ6Xed7WX6DnXw81Ih7bhPm0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Test ssh login key acceptance without having the private key";
    homepage = "https://github.com/benjojo/ssh-key-confirmer";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
