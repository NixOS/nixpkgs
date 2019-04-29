{ stdenv, lib, buildGoPackage, fetchFromGitHub, pkgs }:

buildGoPackage rec {
  name = "mosquitto-go-auth-${version}";
  version = "v0.2.0";
  rev = "0.2.0";

  goPackagePath = "github.com/iegomez/mosquitto-go-auth";

  src = fetchFromGitHub {
    inherit rev;
    owner = "iegomez";
    repo = "mosquitto-go-auth";
    sha256 = "0wmi1w6nzl2nf0shrfb17n61ny625gpys03xlpx4h4sagvlwrsyn";
  };

  goDeps = ./deps.nix;

  buildInputs = with pkgs; [
    mosquitto
  ];

  outputs = [ "out" ];

  dontRenameImports = true;
  allowGoReference = true;

  buildPhase = ''
    cd ./go/src/${goPackagePath}
    export CGO_FLAGS="-I${pkgs.mosquitto}/include -fPIC"
    export CGO_LDFLAGS="-shared"
    go build -buildmode=c-archive go-auth.go
    go build -buildmode=c-shared -o go-auth.so
  '';

  installPhase = ''
    install -m644 -D go-auth.so $out/lib/go-auth.so
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/iegomez/mosquitto-go-auth";
    description = "Auth plugin for mosquitto";
    maintainers = [ maintainers.marenz ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
