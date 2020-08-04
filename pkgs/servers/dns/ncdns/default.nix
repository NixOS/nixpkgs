{ lib, nixosTests, git, buildGoPackage, fetchFromGitHub, libcap }:

buildGoPackage rec {
  pname = "ncdns";
  version = "0.0.10.3";

  goPackagePath = "github.com/namecoin/ncdns";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "ncdns";
    rev = "v${version}";
    sha256 = "12q5al48mkjhgyk7z5wyklzzrdbcqhwxl79axa4gh9ld75prghbq";
  };

  patches = [ ./fix-tpl-path.patch ];

  buildInputs = [ libcap ];

  preBuild = ''
    go generate github.com/namecoin/x509-signature-splice/...
  '';

  postInstall = ''
    mkdir -p "$out/share"
    cp -r "$src/_doc" "$out/share/doc"
    cp -r "$src/_tpl" "$out/share/tpl"
  '';

  meta = with lib; {
    description = "Namecoin to DNS bridge daemon";
    homepage = "https://github.com/namecoin/ncdns";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
  };

  passthru.tests.ncdns = nixosTests.ncdns;

}
