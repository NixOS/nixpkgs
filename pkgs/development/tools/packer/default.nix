{ stdenv, lib, go, gox, goPackages, fetchFromGitHub
, fetchgit, fetchhg, fetchbzr, fetchsvn }:

stdenv.mkDerivation rec {
  name = "packer-${version}";
  version = "0.10.1";

  src = import ./deps.nix {
    inherit stdenv lib go gox goPackages fetchgit fetchhg fetchbzr fetchsvn;
  };

  buildInputs = [ go gox goPackages.tools ];

  configurePhase = ''
    export GOPATH=$PWD/share/go
    export XC_ARCH=$(go env GOARCH)
    export XC_OS=$(go env GOOS)

    mkdir $GOPATH/bin

    cd $GOPATH/src/github.com/mitchellh/packer

    # Don't fetch the deps
    substituteInPlace "Makefile" --replace ': deps' ':'

    # Avoid using git
    sed \
      -e "s|GITBRANCH:=.*||" \
      -e "s|GITSHA:=.*|GITSHA=${src.rev}|" \
      -i Makefile
    sed \
      -e "s|GIT_COMMIT=.*|GIT_COMMIT=${src.rev}|" \
      -e "s|GIT_DIRTY=.*|GIT_DIRTY=|" \
      -i "scripts/build.sh"
  '';

  buildPhase = ''
    make generate releasebin
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = http://www.packer.io;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ];
    platforms   = platforms.unix;
  };
}
