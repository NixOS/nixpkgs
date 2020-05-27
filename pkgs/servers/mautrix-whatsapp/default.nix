{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-05-27";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "7cf19b0908dec6cb8239aebc3f79ee88dccbfc51";
    sha256 = "14cadqvbcjd9vp6dix3jzn0l071r3i9sz0lwpppgzpid8mg9zbx4";
  };

  modSha256 = "1klwbp9cmyp8dj6divalxsw1dfjh0frw57pwfgd2gakmzj35416b";

  buildInputs = [ olm ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
