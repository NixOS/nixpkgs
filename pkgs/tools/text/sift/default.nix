{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "sift-${version}";
  version = "0.8.0";
  rev = "v${version}";

  goPackagePath = "github.com/svent/sift";

  src = fetchFromGitHub {
    inherit rev;
    owner = "svent";
    repo = "sift";
    sha256 = "1nb042k420xr6000ipwhqn41vg8jfp6ghq4z7y1sjnndkrhclzm1";
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
