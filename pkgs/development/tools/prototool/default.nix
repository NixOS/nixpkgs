{ lib, buildGoModule, fetchFromGitHub, makeWrapper, protobuf }:

buildGoModule rec {
  pname = "prototool";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "uber";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m6g5p3jyf0ja5j9rqmw8mhipdqxk7rcxm0plmh65bxk1n22fzjc";
  };

  nativeBuildInputs = [ makeWrapper ];

  modSha256 = "0l4nqb1c1lqqk70l9qwib1azavxlwghi2fv5siwrr5zw4jysz5ml";

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
