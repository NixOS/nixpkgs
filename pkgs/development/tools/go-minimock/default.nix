{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "sha256-t7k4zpZrbaCwTZTngPlJGEmJOVl8onfIPVb2XGXuH5s=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorHash = "sha256-9KKnJQ5eM0UpO1tHebbEVnqwVJZnrls4KXi6BzlgZgM=";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
