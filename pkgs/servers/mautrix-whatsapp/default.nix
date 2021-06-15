{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "unstable-2021-06-15";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "d3b9f4f63744398cd2282c1927d02cb5bdb8c474";
    sha256 = "sha256-ueqAvfgQDTcNIad9fRCKiRpR0vGUJZbf3EmcJpQ2Y/g=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-Iscojrn6wVnweOQV1GvhZ4QjUdTfDLOsCP1hVR4u/b4=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
