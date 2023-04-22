{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-4dOkSnurg2Sk36Z2WNjPaO092IiRlzc9oWM6sQ+wUwM=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-48C9aaOe148emSsxzfKFKtnXyC39IFO8Ge7d+rIhDac=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
