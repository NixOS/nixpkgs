{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-01-07";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "302fae6649f083ae2a1d4431157e6045865f62ad";
    sha256 = "0rnlbw1xqk9kjc23pmybxdznxylpfxl35wa37lkafymfardjjavb";
  };

  modSha256 = "18bcv7x49bqnzwhafh8fvyv9z2d4j6w0iyqql0alq57hy7h7lxik";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
