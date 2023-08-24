{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "container2wasm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    rev = "v${version}";
    hash = "sha256-m8pO7xkYjwvDoDreOPuiKNavFWcHn8Fy+F/eArBWRPM=";
  };

  vendorHash = "sha256-BiQzNXEZ7O+Xb2SQKYVQRMtm/fSmr+PD+RBLpCywkyQ=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "cmd/c2w" ];

  meta = {
    description = "Container to WASM converter";
    homepage = "https://github.com/ktock/container2wasm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "c2w";
  };
}
