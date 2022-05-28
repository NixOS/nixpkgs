{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "json2hcl";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "kvz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H3jDZL/guVwJIZs7PD/rIvH3ZRYQzNTU/iUvy8aXs0o=";
  };

  vendorSha256 = "sha256-GxYuFak+5CJyHgC1/RsS0ub84bgmgL+bI4YKFTb+vIY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert JSON to HCL, and vice versa";
    homepage = "https://github.com/kvz/json2hcl";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
