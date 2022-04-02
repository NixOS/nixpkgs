{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V/x969wi5u5ND9QgJfc4vtI2t1G1ETlATzeqnpHMncc=";
  };

  vendorSha256 = "sha256-LtRHnZF0ynnIp77K9anljqq42BumXohDMwlU7hzSxZk=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${version}"
  ];

  meta = with lib; {
    description = "A modern watch command";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [ j-hui ];
  };
}
