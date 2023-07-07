{ lib, buildGoModule, fetchFromGitHub, makeWrapper, protobuf }:

buildGoModule rec {
  pname = "prototool";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "uber";
    repo = pname;
    rev = "v${version}";
    sha256 = "02ih9pqnziwl2k4z6c59w1p4bxmb3xki5y33pdfkxqn2467s792g";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "0gyj0yrri2j4yxmyn4d4vdhaxf2p08srpjcxg9zpaxwv5rrvipav";

  doCheck = false;

  postInstall = ''
    wrapProgram "$out/bin/prototool" \
      --prefix PROTOTOOL_PROTOC_BIN_PATH : "${protobuf}/bin/protoc" \
      --prefix PROTOTOOL_PROTOC_WKT_PATH : "${protobuf}/include"
  '';

  subPackages = [ "cmd/prototool" ];

  meta = with lib; {
    homepage = "https://github.com/uber/prototool";
    description = "Your Swiss Army Knife for Protocol Buffers";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
