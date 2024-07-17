{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  git,
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "sha256-sSaqcVrJq/ag6urFH2nzpVEFhcQGvXUR7E8NofvTk1A=";
  };

  vendorHash = "sha256-xZ3J0/SxABPnmCw716xXG/XJvlvcfsIBuNl1h/z9i5g=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mycorrhiza \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = with lib; {
    description = "Filesystem and git-based wiki engine written in Go using mycomarkup as its primary markup language";
    homepage = "https://github.com/bouncepaw/mycorrhiza";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ chekoopa ];
    platforms = platforms.linux;
    mainProgram = "mycorrhiza";
  };
}
