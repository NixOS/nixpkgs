{ stdenv, go, fetchgit }:

let
  go-flags = fetchgit {
    url = "git://github.com/jessevdk/go-flags";
    rev = "ef51ed2000ee1721c7153e958511907b844b4a9c";
    sha256 = "1abzc7ksglicaz6g6nry006vwvflsidvyzyig85pi3p852z6sc2j";
  };
  go-runewidth = fetchgit {
    url = "git://github.com/mattn/go-runewidth";
    rev = "63c378b851290989b19ca955468386485f118c65";
    sha256 = "1z5mhfrpqdssn3603vwd95w69z28igwq96lh7b9rrdcx440i822d";
  };
  termbox-go = fetchgit {
    url = "git://github.com/nsf/termbox-go";
    rev = "bb19a81afd4bc2729799d1fedb19f7bd7ee284cf";
    sha256 = "1zc8pb594l16yipis6xg2ra84bg315p63wqxa5abyam1y0333sn0";
  };
in stdenv.mkDerivation rec {
  name = "peco-${version}";
  version = "0.2.10";

  src = fetchgit {
    url = "git://github.com/peco/peco";
    rev = "4952013023ae1d92c10d826e6970c5a68959678d";
    sha256 = "15blxy6a9ph6hm5wn14p025qidbspjy6hhmp4zbbgpxx2l1x8fpg";
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
