{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "sha256-0nwE3+GkJAvz5s8G23TvLVO8ykQK0ZIwEWAaTWHHOuU=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-FRXG0HmYfum9G/LYm6oWLLx1ZYQ3Jq7qV/mq6ofN9f5=";

  doCheck = false;

  runVend = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
