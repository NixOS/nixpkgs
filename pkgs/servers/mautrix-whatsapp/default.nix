{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "1qagp6jnc4n368pg4h3jr9bzpwpbnva1xyl1b1k2a7q4b5fm5yww";
  };

  buildInputs = [ olm ];

  modvendorCopy = true;
  vendorSha256 = "06zp6995jfbl913jb0p685zaszdscri5z7wid94vws1knljpv6d9";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
