{ lib, buildGoPackage, fetchFromSourcehut, nixosTests }:

buildGoPackage rec {
  pname = "phylactery";
  version = "0.1.2";

  goPackagePath = "git.sr.ht/~cnx/phylactery";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "sha256-HQN6wJ/4YeuQaDcNgdHj0RgYnn2NxXGRfxybmv60EdQ=";
  };

  # Upstream repo doesn't provide any test.
  doCheck = false;
  passthru.tests.phylactery = nixosTests.phylactery;

  meta = with lib; {
    description = "Old school comic web server";
    homepage = "https://git.sr.ht/~cnx/phylactery";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
  };
}
