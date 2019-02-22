{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "deis-${version}";
  version = "1.13.4";
  rev = "v${version}";

  goPackagePath = "github.com/deis/deis";
  subPackages = [ "client" ];

  postInstall = ''
    if [ -f "$bin/bin/client" ]; then
      mv "$bin/bin/client" "$bin/bin/deis"
    fi
  '';

  src = fetchFromGitHub {
    inherit rev;
    owner = "deis";
    repo = "deis";
    sha256 = "0hndzvlgpfm83c4i1c88byv8j9clagswa79nny8wrw33dx90dym1";
  };

  preBuild = ''
    export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace
  '';

  meta = with stdenv.lib; {
    homepage = https://deis.io;
    description = "A command line utility used to interact with the Deis open source PaaS.";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      jgeerds
    ];
  };
}
