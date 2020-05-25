{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-04-12";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "44bb623e7a7486a0cdd13fd67b2aaca2ddba20ce";
    sha256 = "1fwxn6511pq9fdc8d2jp4vgkm1zag55pig75qdxfn63hl3i2607k";
  };

  modSha256 = "04pdap1q7zsa1wv2h0j9104fawn95g37yqslmp2mq7722hiqhp9x";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
