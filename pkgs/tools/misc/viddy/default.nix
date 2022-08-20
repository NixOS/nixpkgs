{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+0Twa9OYIuyt1+F/sLkQSOj0u04r7y/DqYd11buquow=";
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
