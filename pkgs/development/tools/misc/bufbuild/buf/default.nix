{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "buf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "buf";
    rev = "v${version}";
    sha256 = "120ncdhlgnyizgfza9zb6ky0sray0iwv9l840b6ffnynqnz1qmbz";
  };

  goPackagePath = "github.com/bufbuild/buf/cmd/buf";

  meta = with lib; {
    description = "Commandline app to manage .proto files";
    longDescription = ''
      The Buf CLI incorporates the following components to help you create consistent Protobuf APIs, 
      such as A linter that enforces good API design choices and structure, a breaking change detector 
      that enforces compatibility at the source code or wire level, agenerator that invokes your 
      protoc plugins based on a configurable template. A protoc replacement that uses Buf's 
      newly-developed high performance Protobuf compiler and a configurable file builder that 
      produces Images, our extension of FileDescriptorSets.
    '';

    license = licenses.apache2;
    homepage = "https://github.com/bufbuild/buf";
    maintainers = with maintainers; [ kaiserkarel ];
    platforms = with platforms; unix;
  };
}


