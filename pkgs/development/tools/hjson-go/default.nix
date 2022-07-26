{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hjson-go";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "hjson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-plsiHxjrZXcnaqN8Frs+VuGwV7JOj8UwB0iibp3ApAk=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Utility to convert JSON to and from HJSON";
    homepage = "https://hjson.github.io/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.mit;
    mainProgram = "hjson-cli";
  };
}
