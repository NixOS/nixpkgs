{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asciigraph";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tImHxTVKFFE5RcHCyJ3dyV6kGp3keZzDRhpHsp+IGB0=";
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
