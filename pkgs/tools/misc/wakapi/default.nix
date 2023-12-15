{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-CyMzhEKaTiLODjXbHqkqEJNeCsssCjmdVOzg3vXVjJY=";
  };

  vendorHash = "sha256-+FYeaIQXHZyrik/9OICl2zk+OA8X9bry7JCQbdf9QGs=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  # Fix up reported version
  postPatch = ''echo ${version} > version.txt'';

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
    mainProgram = "wakapi";
  };
}
