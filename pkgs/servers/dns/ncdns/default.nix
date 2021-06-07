{ lib, nixosTests, git, buildGoPackage, fetchFromGitHub, libcap }:

buildGoPackage rec {
  pname = "ncdns";
  version = "2020-11-22";

  goPackagePath = "github.com/namecoin/ncdns";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "ncdns";
    rev = "2fa54cd3b5480dba82170ab8ecb511fbd4977c41";
    sha256 = "0mrxbg5lmy3s281ff6nxpp03z4mqwq7h5hkqm9qy8nb280x1sx7h";
  };

  patches = [ ./fix-tpl-path.patch ];

  buildInputs = [ libcap ];

  postInstall = ''
    mkdir -p "$out/share"
    cp -r "$src/_doc" "$out/share/doc"
    cp -r "$src/_tpl" "$out/share/tpl"
  '';

  meta = with lib; {
    description = "Namecoin to DNS bridge daemon";
    homepage = "https://github.com/namecoin/ncdns";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rnhmjoj ];
  };

  passthru.tests.ncdns = nixosTests.ncdns;

}
