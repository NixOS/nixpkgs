{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-TEifqWVgZjrQcq9eDjfRgUff9vdsO3Fx2hZZJVJZLsU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Accelerate
    MetalPerformanceShaders
    MetalKit
  ]);

  vendorHash = "sha256-KtpEqGXLpwH0NXFjb0F/SUBxP7BLEiEg3NouC0ZQOPs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
