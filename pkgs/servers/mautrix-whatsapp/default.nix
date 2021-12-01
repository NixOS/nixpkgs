{ lib, buildGo117Module, fetchFromGitHub, olm }:

buildGo117Module rec {
  pname = "mautrix-whatsapp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "sha256-gCbZGlZDwHw+OAlTx3rHlbd4Ntw+RaCEDTiP/1q0oJs=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-4KDLL9FY3DrkGBDlu6G8Fp7XJfXjwLTELspyW+FBGfo=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
