{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "1.2.0";
  pname = "2fa";

  goPackagePath = "rsc.io/2fa";

  src = fetchFromGitHub {
    owner = "rsc";
    repo = "2fa";
    rev = "v${version}";
    sha256 = "sha256-cB5iADZwvJQwwK1GockE2uicFlqFMEAY6xyeXF5lnUY=";
  };

  meta = with lib; {
    homepage = "https://rsc.io/2fa";
    description = "Two-factor authentication on the command line";
    maintainers = with maintainers; [ rvolosatovs ];
    license = licenses.bsd3;
  };
}
