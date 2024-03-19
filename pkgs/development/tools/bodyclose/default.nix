{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bodyclose";
  version = "2023-04-21";

  src = fetchFromGitHub {
    owner = "timakin";
    repo = "bodyclose";
    rev = "574207250966ef48b7c65325648b17ff2c3a900a";
    hash = "sha256-qUt8uOk1vgj2rtzTevGh9c4McxbFKgEw83pq7IAlRdg=";
  };

  vendorHash = "sha256-TSYaY7Rg0ZoXdIN1sTNmgjC4PcVcgwSTuE43FYbzlAs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Golang linter to check whether HTTP response body is closed and a re-use of TCP connection is not blocked";
    mainProgram = "bodyclose";
    homepage = "https://github.com/timakin/bodyclose";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
