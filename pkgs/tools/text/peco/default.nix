{ stdenv, go, fetchgit }:

let
  go-flags = fetchgit {
    url = "git://github.com/jessevdk/go-flags";
    rev = "4f0ca1e2d1349e9662b633ea1b8b8d48e8a32533";
    sha256 = "5f22f4c5a0529ff0da8e507462ad910bb73c513fde49d58dd4baf7332787ca3d";
  };
  go-runewidth = fetchgit {
    url = "git://github.com/mattn/go-runewidth";
    rev = "36f63b8223e701c16f36010094fb6e84ffbaf8e0";
    sha256 = "718e9e04659441744b8d43bd3d7e806836194cf322962712a6e019311d407ecf";
  };
  termbox-go = fetchgit {
    url = "git://github.com/nsf/termbox-go";
    rev = "4e63c3a917c197694cb4fef6c55582500b3741e3";
    sha256 = "00ecc0dcf0919a42ea06fe3bd93480a17241160c434ff3872b6f5e418eb18069";
  };
in stdenv.mkDerivation rec {
  name = "peco-${version}";
  version = "0.2.3";

  src = fetchgit {
    url = "git://github.com/peco/peco";
    rev = "b8e0c8f37d3eed68e64c931b0edb77728f3723f9";
    sha256 = "f178e01ab0536770b17eddcefd863e68c2d65b527b5da1fc3fb9efb19c12635f";
  };

  buildInputs = [ go ];

  sourceRoot = ".";

  buildPhase = ''
    mkdir -p src/github.com/jessevdk/go-flags/
    ln -s ${go-flags}/* src/github.com/jessevdk/go-flags

    mkdir -p src/github.com/mattn/go-runewidth/
    ln -s ${go-runewidth}/* src/github.com/mattn/go-runewidth

    mkdir -p src/github.com/nsf/termbox-go/
    ln -s ${termbox-go}/* src/github.com/nsf/termbox-go

    mkdir -p src/github.com/peco/peco
    ln -s ${src}/* src/github.com/peco/peco

    export GOPATH=$PWD
    go build -v -o peco src/github.com/peco/peco/cmd/peco/peco.go
  ''; # */

  installPhase = ''
    ensureDir $out/bin
    cp peco $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Simplistic interactive filtering tool";
    homepage = https://github.com/peco/peco;
    license = licenses.mit;
    # peco should work on Windows or other POSIX platforms, but the go package
    # declares only linux and darwin.
    platforms = platforms.linux ++ platforms.darwin;
  };
}
