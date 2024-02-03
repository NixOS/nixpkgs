{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "json2hcl";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "kvz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0ku8sON4fzWAirqY+dhYAks2LSyC7OH/LKI0kb+QhpM=";
  };

  vendorHash = "sha256-GxYuFak+5CJyHgC1/RsS0ub84bgmgL+bI4YKFTb+vIY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert JSON to HCL, and vice versa";
    homepage = "https://github.com/kvz/json2hcl";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
