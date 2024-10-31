{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ejson";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson";
    rev = "v${version}";
    sha256 = "sha256-Pv0eoFf/E+PE/C+0wsSQxhVTlymOMAYk5UVQP2udpnA=";
  };

  vendorHash = "sha256-N2vcj3STkaZO2eRr8VztZTWOBUTI+wOri0HYDJ1KiN8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Small library to manage encrypted secrets using asymmetric encryption";
    mainProgram = "ejson";
    license = licenses.mit;
    homepage = "https://github.com/Shopify/ejson";
    maintainers = [ maintainers.manveru ];
  };
}
