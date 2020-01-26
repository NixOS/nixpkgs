{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-01-12";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "39e46833b471b0cf262d4ff57fcd61530b5d2b9e";
    sha256 = "1r1f52advibb97vrhi2gw0d0scnsvfbmfqizsbpjmgm7ci9jjhcl";
  };

  modSha256 = "18bcv7x49bqnzwhafh8fvyv9z2d4j6w0iyqql0alq57hy7h7lxik";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
