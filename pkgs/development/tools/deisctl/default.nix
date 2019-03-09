{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "deis-${version}";
  version = "1.13.3";
  rev = "v${version}";

  goPackagePath = "github.com/deis/deis";
  subPackages = [ "deisctl" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "deis";
    repo = "deis";
    sha256 = "15q44jyjms8fdmly0z4sn4ymf1dx6cmdavgixjixdj2wbjw0yi2p";
  };

  preBuild = ''
    export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace
  '';

  meta = with stdenv.lib; {
    homepage = https://deis.io;
    description = "A command-line utility used to provision and operate a Deis cluster.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      jgeerds
    ];
  };
}
