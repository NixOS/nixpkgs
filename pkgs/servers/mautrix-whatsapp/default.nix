{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "sha256-PXahSrA+jBWreFhqCp1Ar9yYfIJGJfU2xH88Ax3fdkE=";
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
