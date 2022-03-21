{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "M44APMnpQU+9TTJu4NF528o0JvGvWja4H7XUcAHtxrA=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "o3KTcnMd6Tqt9QIfW29wvN8POIFThNg8AdeGDF5wbVc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
