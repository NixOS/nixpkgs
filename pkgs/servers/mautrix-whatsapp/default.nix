{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mautrix-unstable-${version}";
  version = "2019-02-20";

  goPackagePath = "maunium.net/go/mautrix-whatsapp";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "c5aac5e770d40fe5d5549a2939b92f0c103d8165";
    sha256 = "093n8x4c2pdj7idzdnssys7260v5fmay1y6r1l39q16k0qsfsl6r";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ];
  };
}
