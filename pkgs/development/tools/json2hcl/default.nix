{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "json2hcl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kvz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h7DudYVWvDRCbjoIgOoCIudf7ZfUfWXp5OJ4ni0nm6c=";
  };

  vendorHash = "sha256-GxYuFak+5CJyHgC1/RsS0ub84bgmgL+bI4YKFTb+vIY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert JSON to HCL, and vice versa";
    mainProgram = "json2hcl";
    homepage = "https://github.com/kvz/json2hcl";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
