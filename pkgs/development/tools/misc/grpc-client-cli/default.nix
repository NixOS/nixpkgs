{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-ckvCgwpgEK/GJ+uqe81Gv3tx3sFlSKdh1nwLZU6LoHs=";
  };

  vendorSha256 = "sha256-QcBPbwWVdjPFTEifKGtZH9wr7UI5OKcyWfVa8aWs4iA=";

  meta = with lib; {
    description = "generic gRPC command line client";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}
