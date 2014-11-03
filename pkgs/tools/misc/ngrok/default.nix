{ stdenv, lib, go, go-bindata, fetchgit, fetchbzr, fetchhg, fetchFromGitHub }:

let deps = import ./deps.nix {
  inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
};
in stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "1.7";

  buildInputs = [ go go-bindata ];

  unpackPhase = ''
    export GOPATH=$(pwd)
    cp -LR ${deps}/src src
    chmod u+w -R src
    sourceRoot=src/github.com/inconshreveable/ngrok
  '';

  preBuild = ''
    export HOME=$(pwd)
    export GOPATH=$(pwd):$GOPATH

    # don't download dependencies as we already have them
    sed -i '/jteeuwen\/go-bindata/d' Makefile
    sed -i '/export GOPATH/d' Makefile
    sed -i 's|bin/go-bindata|go-bindata|' Makefile
  '';

  installPhase = ''
    make release-client release-server
    mkdir -p $out/bin
    cp bin/ngrok{d,} $out/bin
  '';

  meta = with lib; {
    description = "Reverse proxy that creates a secure tunnel between from a public endpoint to a locally running web service";
    homepage = https://ngrok.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ iElectric cstrahan ];
    platforms = with platforms; linux ++ darwin;
  };
}
