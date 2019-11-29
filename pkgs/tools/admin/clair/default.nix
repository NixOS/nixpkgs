{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoPackage rec {
  pname = "clair";
  version = "2.0.9";

  goPackagePath = "github.com/coreos/clair";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lcrqka4daqqjagx2mbfzg3z8wxg669mw1lb450nrlc33ji2iwdm";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/coreos/clair";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
