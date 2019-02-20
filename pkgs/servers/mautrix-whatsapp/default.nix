{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mautrix-unstable-${version}";
  version = "2019-02-11";

  goPackagePath = "maunium.net/go/mautrix-whatsapp";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "f689297ba6704265a938951f307b365e829fcfa1";
    sha256 = "1658bika9ylhm64k9lxavp43dxilygn6vx7yn6y1l10j8by2akxk";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ];
  };
}
