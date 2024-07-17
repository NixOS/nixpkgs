{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  nixosTests,
}:

buildGoModule rec {
  pname = "phylactery";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    hash = "sha256-HQN6wJ/4YeuQaDcNgdHj0RgYnn2NxXGRfxybmv60EdQ=";
  };

  vendorHash = null;

  preBuild = ''
    cp ${./go.mod} go.mod
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.phylactery = nixosTests.phylactery;

  meta = with lib; {
    description = "Old school comic web server";
    mainProgram = "phylactery";
    homepage = "https://git.sr.ht/~cnx/phylactery";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
  };
}
