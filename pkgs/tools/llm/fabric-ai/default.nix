{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule {
  pname = "fabric-ai";
  version = "1.4.72";

  src = pkgs.fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    rev = "v1.4.72";
    sha256 = "sha256-fPg7D7Ar543SjQ/f/HpyBbZx+sVcSbcHezUFY7q/iVs=";
  };

  vendorHash ="sha256-/nQj0T52xT3MGyM7hsPvvncXlZWjbjA2NBCisidgoWY=";

  meta = with pkgs.lib; {
    description = "An open-source framework for augmenting humans using AI";
    homepage = "https://github.com/danielmiessler/fabric";
    mainProgram = "fabric";
    license = licenses.mit;
    maintainers = [ "DJE98" ];
  };
}

