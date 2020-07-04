{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "1df6m1jjv8la6qcz3c5a6pw0jk81f1khx3d9q17d6v3ihrki8krk";
  };

  buildInputs = [ olm ];

  modSha256 = "1m4aa6bzsn9wa577abnsnkj5qzkk42z54k17xvybc47a9inc5gp8";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
