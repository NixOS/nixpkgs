{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-gpTJObgLbH+4fBnBrI6YA3Y4ENuGHV6xP7oHbSFQyEw=";
  };

  vendorHash = "sha256-FuUxCm/p8ke55kMjsmHwZTJMWO4cQZZ/B1RDpdxUr8U=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
