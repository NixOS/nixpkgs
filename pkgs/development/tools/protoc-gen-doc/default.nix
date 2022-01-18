{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "protoc-gen-doc-unstable";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "pseudomuto";
    repo = "protoc-gen-doc";
    rev = "v${version}";
    sha256 = "1bpb5wv76p0sjffh5d1frbygp3q1p07sdh5c8pznl5bdh5pd7zxq";
  };

  vendorSha256 = "08pk9nxsl28dw3qmrlb7vsm8xbdzmx98qwkxgg93ykrhzx235k1b";

  doCheck = false;

  meta = with lib; {
    description = "Documentation generator plugin for Google Protocol Buffers";
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
