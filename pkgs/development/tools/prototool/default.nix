{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, protobuf, Security }:

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

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  modSha256 = "1gc8kc9mbi3mlh48zx4lcgpsrf8z879f1qj9wfyr66s7wd1ljazg";

  postInstall = ''
    wrapProgram "$out/bin/prototool" \
      --prefix PROTOTOOL_PROTOC_BIN_PATH : "${protobuf}/bin/protoc" \
      --prefix PROTOTOOL_PROTOC_WKT_PATH : "${protobuf}/include"
  '';

  subPackages = [ "cmd/prototool" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/uber/prototool";
    description = "Your Swiss Army Knife for Protocol Buffers";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
