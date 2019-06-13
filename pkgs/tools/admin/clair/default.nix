{ lib, buildGoPackage, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoPackage rec {
  pname = "clair";
  version = "2.0.7";

  goPackagePath = "github.com/coreos/clair";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "clair";
    rev = "v${version}";
    sha256 = "0n4pxdw71hd1rxzgf422fvycpjkrxxnvcidys0hpjy7gs88zjz5x";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = https://github.com/coreos/clair;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
