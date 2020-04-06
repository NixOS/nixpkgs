{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-04-02";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "064b5b8fedb6896d04509aa0e094a8d9f83426c2";
    sha256 = "1xky31x5jk7yxh875nk20vvsn9givy6vxdqhqg5qwf4xjj2zqh2p";
  };

  modSha256 = "0qcxxhfp3fkx90r3lwhi0lkzg3digwrnxk8cack11k717szg7zrd";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
