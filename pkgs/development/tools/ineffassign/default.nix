{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "ineffassign-unstable-${version}";
  version = "2018-09-09";
	rev = "1003c8bd00dc2869cb5ca5282e6ce33834fed514";

  goPackagePath = "github.com/gordonklaus/ineffassign";
  excludedPackages = ''testdata'';

  src = fetchFromGitHub {
    inherit rev;

    owner = "gordonklaus";
    repo = "ineffassign";
    sha256 = "1rkzqvd3z03vq8q8qi9cghvgggsf02ammj9wq8jvpnx6b2sd16nd";
  };

  meta = with lib; {
    description = "Detect ineffectual assignments in Go code.";
    homepage = https://github.com/gordonklaus/ineffassign;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
