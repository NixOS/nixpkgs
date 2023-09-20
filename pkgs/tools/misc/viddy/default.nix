{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-82q73L0641d5qNmB+WLkUmDP5OHMoj2SNFc+FhknhwU=";
  };

  vendorHash = "sha256-FMSgLI1W5keRnSYVyY0XuarMzLWvm9D1ufUYmZttfxk=";

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
