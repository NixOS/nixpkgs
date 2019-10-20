{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "json2hcl";
  version = "0.0.6";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "0knil88n2w41w3nzqz6ljgfjkl5r3x0bh7ifqgiyf6sin3pl4pn0";
  };

  owner = "kvz";
  goPackagePath = "github.com/${owner}/${pname}";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Convert JSON to HCL, and vice versa";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
