{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tml";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "tml";
    rev = "v${version}";
    hash = "sha256-92GumJGdbqxhcIj1gdkiamUA4peDG/Ar6GEimj/E7lg=";
  };

  vendorHash = "sha256-YsEmxhyDMuvq48vdHFvgsIqbqDZbg8beS0nL7lsaFJ0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tiny markup language for terminal output";
    homepage = "https://github.com/liamg/tml";
    changelog = "https://github.com/liamg/tml/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
  };
}
