{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-p2YLgLyjmf2MPvFue45+wW7kqKpUli9rX3aWNH08cDk=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Accelerate
    MetalPerformanceShaders
    MetalKit
  ]);

  vendorHash = "sha256-IgEf/WOc1eNGCif1fViIFxbgZAd6mHBqfxcaqH/WvGg=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
