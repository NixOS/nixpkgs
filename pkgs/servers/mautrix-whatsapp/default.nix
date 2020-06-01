{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-05-29";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "7947ba616ca1b776883ca7db9cab8de9ee8d9ee6";
    sha256 = "10rkkjnbppv9gi67hknijh8ib841qyy16grdw29gz3ips6qs8zq7";
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
