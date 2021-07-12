{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gox";
  version = "1.0.1";

  goPackagePath = "github.com/mitchellh/gox";

  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "gox";
    rev = "v${version}";
    sha256 = "0mkh81hd7kn45dz7b6yhzqsg2mvg1g6pwx89jjigxrnqhyg9vrl7";
  };

  meta = with lib; {
    homepage = "https://github.com/mitchellh/gox";
    description = "A dead simple, no frills Go cross compile tool";
    license = licenses.mpl20;
  };
}
