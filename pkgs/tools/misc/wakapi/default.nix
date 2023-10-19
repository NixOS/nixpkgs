{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-r6CTWBsaaYzQE9pe3rj/BQudloKGlkf310r39Y0kYuM=";
  };

  vendorHash = "sha256-uVdjMgQ1zWFKNwTKIHd7O47oekE9tLBh8LgFgI1SATM=";

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
