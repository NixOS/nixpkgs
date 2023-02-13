{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "txtpbfmt";
  version = "unstable-2023-01-18";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "fcc1fa29197ce17bc56812f84f5ff311f767fcd1";
    hash = "sha256-U+Kk2tQw+rJX7Xa8b5Hd7x0xY/6PN6TTYsLJkpB1Osg=";
  };

  vendorHash = "sha256-shjcQ3DJQYeAW0bX3OuF/esgIvrQ4yuLEa677iFV82g=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
