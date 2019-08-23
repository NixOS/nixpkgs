{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoPackage rec {
  pname = "clair";
  version = "2.0.8";

  goPackagePath = "github.com/coreos/clair";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gwn533fdz8daz1db7w7g7mhls7d5a4vndn47blkpbx2yxdwdh62";
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
