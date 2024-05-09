{ lib, libusb1, buildGoModule, fetchFromGitHub, pkg-config }:

buildGoModule rec {
  pname = "yubihsm-connector";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-connector";
    rev = version;
    hash = "sha256-snoQZsmKQPcsB5EpZc4yon02QbxNU5B5TAwRPjs1O5I=";
  };

  vendorHash = "sha256-XW7rEHY3S+M3b6QjmINgrCak+BqCEV3PJP90jz7J47A=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  ldflags = [ "-s" "-w" ];

  preBuild = ''
    GOOS= GOARCH= go generate
  '';

  meta = with lib; {
    description = "yubihsm-connector performs the communication between the YubiHSM 2 and applications that use it";
    homepage = "https://developers.yubico.com/yubihsm-connector/";
    maintainers = with maintainers; [ matthewcroughan ];
    license = licenses.asl20;
    mainProgram = "yubihsm-connector";
  };
}
