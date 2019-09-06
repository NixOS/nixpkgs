{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-unstable";
  version = "2019-09-03";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "22fb5c125db1a0a3a8be8e8e09e92bb38718e6bf";
    sha256 = "03wd6mn9jr1hr3qxg1r707ibi1s9511y97bfrmzka4mrsymgamxa";
  };

  modSha256 = "14bqxx2hcr8yhcd5hi087pyc1hzqmr13p2fqb3nnsx12j7n07gww";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
