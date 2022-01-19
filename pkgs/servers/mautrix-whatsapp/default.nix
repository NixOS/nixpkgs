{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-vMRmxu1TNCw5c+PuSdAPdMJpZGLdcCTzpTNz/AFrWi8=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-aX2dWoctVjx13eAu/5DWku5GFxFBuP/RRBs1+7CStDU=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
