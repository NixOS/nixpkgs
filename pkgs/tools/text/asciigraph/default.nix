{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asciigraph";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pCfjk8ViMY2iAus2/hibSZXgKY9YBFRH3vsD19MTJ+8=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    mainProgram = "asciigraph";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
