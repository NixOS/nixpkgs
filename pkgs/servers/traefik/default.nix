{ stdenv, buildGoPackage, fetchurl, bash, go-bindata}:

buildGoPackage rec {
  name = "traefik-${version}";
  version = "v1.3.8";

  goPackagePath = "github.com/containous/traefik";

  src = fetchurl {
    url = "https://github.com/containous/traefik/releases/download/${version}/traefik-${version}.src.tar.gz";
    sha256 = "6fce36dd30bb5ae5f91e69f2950f22fe7a74b920e80c6b441a0721122f6a6174";
  };

  buildInputs = [ go-bindata ];
  sourceRoot = ".";
  postUnpack = ''
  files=`ls`
  mkdir traefik
  mv $files traefik/
  export sourceRoot="traefik"
  '';

  buildPhase = ''
  cd go/src/github.com/containous/traefik
  ${bash}/bin/bash ./script/make.sh generate
  CGO_ENABLED=0 GOGC=off go build -v -ldflags "-s -w" -a -installsuffix nocgo -o dist/traefik ./cmd/traefik
  '';

  installPhase = ''
  mkdir -p $bin/bin
  cp ./dist/traefik $bin/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://traefik.io;
    description = "Træfik, a modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ hamhut1066 ];
  };
}
