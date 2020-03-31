{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule {
  pname = "protoc-gen-doc-unstable";
  version = "2019-04-22";

  src = fetchFromGitHub {
    owner = "pseudomuto";
    repo = "protoc-gen-doc";
    rev = "f824a8908ce33f213b2dba1bf7be83384c5c51e8";
    sha256 = "004axh2gqc4f115mdxxg59d19hph3rr0bq9d08n3nyl315f590kj";
  };

  modSha256 = "1952ycdkgl00q2s3qmhislhhim15nn6nmlkwbfdvrsfzznqj47rd";

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
