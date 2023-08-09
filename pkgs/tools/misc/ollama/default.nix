{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, darwin
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-O8++opfUMQErE3/qeicnCzTGcmT+mA4Kugpp7ZTptZI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Accelerate
    MetalPerformanceShaders
    MetalKit
  ]);

  vendorHash = "sha256-jlJf2RtcsnyhyCeKkRSrpg4GGB2r5hOa3ZmM+UZcIxI=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
