{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mautrix-unstable-${version}";
  version = "2019-02-24";

  goPackagePath = "maunium.net/go/mautrix-whatsapp";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "485acf6de654b8fb70007876c074fb004eb9717b";
    sha256 = "1v7h3s8h0aiq6g06h9j1sidw8y5aiw24sgdh9knr1c90pvvc7pmv";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ];
  };
}
