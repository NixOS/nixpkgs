{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "webhook";
  version = "2.7.0";

  goPackagePath = "github.com/adnanh/webhook";
  excludedPackages = [ "test" ];

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
    sha256 = "1spiqjy0z84z96arf57bn6hyvfsd6l8w6nv874mbis6vagifikci";
  };

  meta = with lib; {
    homepage = "https://github.com/adnanh/webhook";
    license = [ licenses.mit ];
    description = "incoming webhook server that executes shell commands";
  };
}
