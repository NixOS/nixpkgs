{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "envsubst";
  version = "1.1.0";

  goPackagePath = "github.com/a8m/envsubst";
  src = fetchFromGitHub {
    owner = "a8m";
    repo = "envsubst";
    rev = "v${version}";
    sha256 = "1d6nipagjn40n6iw1p3r489l2km5xjd5db9gbh1vc5sxc617l7yk";
  };

  meta = with lib; {
    description = "Environment variables substitution for Go";
    homepage = https://github.com/a8m/envsubst;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ nicknovitski ];
  };
}
