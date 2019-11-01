{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "webhook";
  version = "2.6.8";

  goPackagePath = "github.com/adnanh/webhook";
  excludedPackages = [ "test" ];

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
    sha256 = "05q6nv04ml1gr4k79czg03i3ifl05xq29iapkgrl3k0a36czxlgs";
  };

  meta = with lib; {
    homepage = https://github.com/adnanh/webhook;
    license = [ licenses.mit ];
    description = "incoming webhook server that executes shell commands";
  };
}
