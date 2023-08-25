{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-5EUXhKv4cLDaHr6Q2mel3YbVPAYRJd1JtHyWn7kQy8Y=";
  };

  vendorHash = "sha256-rwQeIHJAtnRm5nPQCvgoBabVeyLZyrY3yglCW9+NGwM=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "A minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ t4ccer ];
  };
}
