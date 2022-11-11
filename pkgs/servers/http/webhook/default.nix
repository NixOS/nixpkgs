{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "webhook";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "adnanh";
    repo = "webhook";
    rev = version;
    sha256 = "0n03xkgwpzans0cymmzb0iiks8mi2c76xxdak780dk0jbv6qgp5i";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  doCheck = false;

  meta = with lib; {
    description = "Incoming webhook server that executes shell commands";
    homepage = "https://github.com/adnanh/webhook";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
