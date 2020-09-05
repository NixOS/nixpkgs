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

  vendorSha256 = "01yr5321paqifmgzz235lknsa0w4hbs3182y6pxw8hqsvh18c48b";

  doCheck = false;

  runVend = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
