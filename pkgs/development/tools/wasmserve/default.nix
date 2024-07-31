{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wasmserve";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hajimehoshi";
    repo = "wasmserve";
    rev = "v${version}";
    hash = "sha256-KlCbUre6yIorE1ZM++Rto8vgwVGsC1wZj1xCd3AwQy0=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "HTTP server for testing Wasm";
    mainProgram = "wasmserve";
    homepage = "https://github.com/hajimehoshi/wasmserve";
    license = licenses.asl20;
    maintainers = with maintainers; [ kirillrdy ];
  };
}
