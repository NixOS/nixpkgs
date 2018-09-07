{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sift-${version}";
  version = "0.9.0";
  rev = "v${version}";

  goPackagePath = "github.com/svent/sift";

  src = fetchFromGitHub {
    inherit rev;
    owner = "svent";
    repo = "sift";
    sha256 = "0bgy0jf84z1c3msvb60ffj4axayfchdkf0xjnsbx9kad1v10g7i1";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "sift is a fast and powerful alternative to grep";
    homepage = https://sift-tool.org;
    maintainers = [ maintainers.carlsverre ];
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
