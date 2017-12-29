{ stdenv, buildGoPackage, fetchurl, bash, go-bindata}:

buildGoPackage rec {
  name = "traefik-${version}";
  version = "1.3.8";

  goPackagePath = "github.com/containous/traefik";

  src = fetchurl {
    url = "https://github.com/containous/traefik/releases/download/v${version}/traefik-v${version}.src.tar.gz";
    sha256 = "6fce36dd30bb5ae5f91e69f2950f22fe7a74b920e80c6b441a0721122f6a6174";
  };

  buildInputs = [ go-bindata bash ];
  unpackPhase = ''
    runHook preUnpack
    mkdir traefik
    tar -C traefik -xvzf $src
    export sourceRoot="traefik"
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    (
      cd go/src/github.com/containous/traefik
      bash ./script/make.sh generate

      CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)
      go build -ldflags "\
        -X github.com/containous/traefik/version.Version=${version} \
        -X github.com/containous/traefik/version.Codename=$CODENAME \
      " -a -o $bin/bin/traefik ./cmd/traefik
    )
    runHook postBuild
  '';

  meta = with stdenv.lib; {
    homepage = https://traefik.io;
    description = "A modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ hamhut1066 ];
  };
}
