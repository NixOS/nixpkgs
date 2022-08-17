{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-hK4I2LVvw7hkbUKRuDoaRuNX3nwlwipYucnXwzOCcXs=";
  };

  vendorSha256 = "sha256-bAM+NxD7mNd2fFxRDHCAzJTD7PVfT/9XHF88v9RHKwE=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ superherointj ];
  };
}

