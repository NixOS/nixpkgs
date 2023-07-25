{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
    sha256 = "sha256-1EMSrHx6Tx58voz5veyNZg1gnubuGyg2K4dg2QdzmMw=";
  };

  vendorHash = "sha256-0wHXULDKyXYBTGxfSQXT/5NidPtSnx7ujb8vyczmE38=";

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
