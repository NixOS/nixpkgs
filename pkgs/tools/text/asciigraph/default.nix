{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asciigraph";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7sobelRCDY8mC5FYyGZmNsvUsEMxRulqPnUucNRN5J8=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
