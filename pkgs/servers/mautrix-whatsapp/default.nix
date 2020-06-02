{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-06-01";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "f1b50a22f3c3d54dfb7df12bb607dee8638259d6";
    sha256 = "1fy8wqjrjnlv60xj7i6dflkw9kx3i7c7mwgqjjkg6afmmhmwr559";
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
