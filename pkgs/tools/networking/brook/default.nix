{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20240214";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5+AqlmDa11PrB24XkelOFHK4sBi4j78WMLQrzDuP1/M=";
  };

  vendorHash = "sha256-cTw9k4AqS4NOJ0vX0InR0xxOfCXIgA3FxgL6oXryOnA=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
