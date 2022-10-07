{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-MZEsThE0cajIJXvsuefNjQMAmnATNCWYBVVJQnd+q6c=";
  };

  vendorSha256 = "sha256-4rU2r0hOR+XCZubLZCNnqoJ1br/WNtb70HN5urat5jQ=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
