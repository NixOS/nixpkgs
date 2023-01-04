{ lib, buildGoModule, fetchFromSourcehut, nixosTests }:

buildGoModule rec {
  pname = "phylactery";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    hash = "sha256-HQN6wJ/4YeuQaDcNgdHj0RgYnn2NxXGRfxybmv60EdQ=";
  };

  vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  preBuild = ''
    cp ${./go.mod} go.mod
  '';

  ldflags = [ "-s" "-w" ];

  passthru.tests.phylactery = nixosTests.phylactery;

  meta = with lib; {
    description = "Old school comic web server";
    homepage = "https://git.sr.ht/~cnx/phylactery";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
  };
}
