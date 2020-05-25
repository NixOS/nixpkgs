{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-05-21";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "b4949eec5982643502bb9787cf5e2872a78807c1";
    sha256 = "1hjqxqfza6r7fsxr4fgwhfdwjzligxk416692xi4pavd5krfxxmd";
  };

  buildInputs = [ olm ];

  vendorSha256 = "0ix65b48cpx6vkqmjizzij7zl8h2kjkfsa0s42vnmjdlmsv7yn42";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
