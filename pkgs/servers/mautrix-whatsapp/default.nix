{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mautrix-unstable";
  version = "2019-07-04";

  goPackagePath = "maunium.net/go/mautrix-whatsapp";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "29f5ae45c4b22f463003b23e355b951831f08b3e";
    sha256 = "12209m3x01i7bnnkg57ag1ivsk6n6pqaqfin7y02irgi3i3rm31r";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ];
  };
}
