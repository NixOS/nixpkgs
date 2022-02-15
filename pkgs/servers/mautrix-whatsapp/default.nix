{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-vMRmxu1TNCw5c+PuSdAPdMJpZGLdcCTzpTNz/AFrWi8=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-bvbZ7Tnd6s6zr9trN4egR/9KV5cU09mQI+U1UxyYzlE=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
