{ lib, buildGoPackage, fetchFromGitHub, webhook, testVersion }:

buildGoPackage rec {
  pname = "webhook";
  version = "2.8.0";

  goPackagePath = "github.com/adnanh/webhook";
  excludedPackages = [ "test" ];

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
    sha256 = "0n03xkgwpzans0cymmzb0iiks8mi2c76xxdak780dk0jbv6qgp5i";
  };

  passthru.tests.version = testVersion { package = webhook; };

  meta = with lib; {
    homepage = "https://github.com/adnanh/webhook";
    license = [ licenses.mit ];
    description = "incoming webhook server that executes shell commands";
  };
}
