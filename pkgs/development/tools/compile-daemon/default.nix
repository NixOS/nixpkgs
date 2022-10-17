{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "compile-daemon";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "githubnemo";
    repo = "CompileDaemon";
    rev = "v${version}";
    sha256 = "sha256-gpyXy7FO7ZVXJrkzcKHFez4S/dGiijXfZ9eSJtNlm58=";
  };

  vendorSha256 = "sha256-UDPOeg8jQbDB+Fr4x6ehK7UyQa8ySZy6yNxS1xotkgA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Very simple compile daemon for Go";
    homepage = "https://github.com/githubnemo/CompileDaemon";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "CompileDaemon";
  };
}
