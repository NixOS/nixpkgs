{ lib, buildGoModule, fetchFromGitHub, makeWrapper, protobuf }:

buildGoModule rec {
  pname = "prototool";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "uber";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ssgvhcnqffhhdx8hnk4lmklip2f6g9i7ifblywfjylb08y7iqgd";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "19wza3vkkda44cng8m6f9y7qpzrgk2adyjmcafk17v4773rxlncf";

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
    platforms = platforms.unix;
  };
}