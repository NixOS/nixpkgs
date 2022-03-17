{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "M44APMnpQU+9TTJu4NF528o0JvGvWja4H7XUcAHtxrA=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-/sj8PXHgMS+uYI6hghKx3sJViUSh82wxjO6Z4gxDHqw=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
