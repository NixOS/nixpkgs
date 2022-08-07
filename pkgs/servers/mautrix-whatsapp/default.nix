{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    sha256 = "zhFc6BAurjrp0pHa48Eb8Iypww6o6YXPXp2ba2CXB6Q=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "EiaQDEsysTiXNHKhbfGVgVdMKgfdUHm48eooGR1rtQg=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
