{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "0cjgyn311zvpdsagyndkw89bvdrcli5kqznss8dsh05wrllxp3x4";
  };

  buildInputs = [ olm ];

  modSha256 = "0jv0xxkz75ny0v74cyhnn57w3qj6gsc8filinnfclnyq8fh0c8wq";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
