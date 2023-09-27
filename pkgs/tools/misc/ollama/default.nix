{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-gtkB38BXI8R+mL4uB4J8decVXIVO58hwoNPCA/f9oPQ=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Accelerate
    MetalPerformanceShaders
    MetalKit
  ]);

  vendorHash = "sha256-fhlRMFVCqhkBfscmIhnMHOZPiUAg/FABI5Ab90dVxg4=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
