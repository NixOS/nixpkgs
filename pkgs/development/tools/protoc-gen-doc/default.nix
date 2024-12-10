{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "protoc-gen-doc";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "pseudomuto";
    repo = "protoc-gen-doc";
    rev = "v${version}";
    sha256 = "sha256-19CN62AwqQGq5Gb5kQqVYhs+LKsJ9K2L0VAakwzPD5Y=";
  };

  vendorHash = "sha256-K0rZBERSKob5ubZW28QpbcPhgFKOOASkd9UyC9f8gyQ=";

  meta = with lib; {
    description = "Documentation generator plugin for Google Protocol Buffers";
    mainProgram = "protoc-gen-doc";
    longDescription = ''
      This is a documentation generator plugin for the Google Protocol Buffers
      compiler (protoc). The plugin can generate HTML, JSON, DocBook and
      Markdown documentation from comments in your .proto files.

      It supports proto2 and proto3, and can handle having both in the same
      context.
    '';
    homepage = "https://github.com/pseudomuto/protoc-gen-doc";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
