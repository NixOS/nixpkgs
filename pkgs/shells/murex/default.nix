{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "3.0.9310";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UjEEP5gDS20PXgzeN1q/j9eydEF/EaB2+TyugHPbbqE=";
  };

  vendorHash = "sha256-vr8r0C01FlJOiAJjbkHxxFpC8hlQNPdoWGARZUl8YGs=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
