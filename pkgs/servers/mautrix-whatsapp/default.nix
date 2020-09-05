{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "1c77f3ffm6m9j8q9p1hb9i8zrqqpvfkr9ffamly44gs7xddmv9sv";
  };

  buildInputs = [ olm ];

  modSha256 = "14dc2zq2w95imrvvx3rrc4lvc71jbv9pa5v1pks41553cawkhbcr";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
