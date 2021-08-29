{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "crafty";
  version = "25.0.1";

  src = fetchurl {
    url = "http://www.craftychess.com/downloads/source/crafty-${version}.zip";
    sha256 = "0aqgj2q7kdlgbha01qs869cwyja13bc7q2lh4nfhlba2pklknsm8";
  };

  bookBin = fetchurl {
    url = "http://www.craftychess.com/downloads/book/book.bin";
    sha256 = "10rrgkr3hxm7pxdbc2jq8b5g74gfhzk4smahks3k8am1cmyq4p7r";
  };

  startPgn = fetchurl {
    url = "http://craftychess.com/downloads/book/start.pgn.gz";
    sha256 = "12g70mgfifwssfvndzq94pin34dizlixhsga75vgj7dakysi2p7f";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    mkdir "craftysrc"
    unzip $src -d craftysrc
    gunzip -c $startPgn > "craftysrc/start.pgn"
  '';

  buildPhase = ''
    cd craftysrc
    make unix-gcc
  '';

  installPhase = ''
    BUILDDIR="$PWD"
    mkdir -p $out/bin
    cp -p ./crafty $out/bin

    mkdir -p $out/share/crafty
    cd $out/share/crafty

    $out/bin/crafty "books create $BUILDDIR/start.pgn 60"
    rm -f *.001

    cp -p ${bookBin} $out/share/crafty/book.bin

    mv $out/bin/crafty $out/bin/.crafty-wrapped

    cat - > $out/bin/crafty <<EOF
    #! ${stdenv.shell}
    #
    # The books are copied from share/crafty to ~/.crafty/books the first time
    # this script is run. You can restore them at any time just copying them
    # again.
    if [[ ! -d "\$HOME/.crafty/books" ]]; then
      mkdir "\$HOME/.crafty/books" -p
      cp "$out/share/crafty/"book*.bin "\$HOME/.crafty/books"
      chmod ug+w "\$HOME/.crafty/books/"*
    fi
    exec $out/bin/.crafty-wrapped bookpath=\$HOME/.crafty/books "\$@"
    EOF
    chmod +x $out/bin/crafty
  '';

  meta = {
    homepage = "http://www.craftychess.com/";
    description = "Chess program developed by Dr. Robert M. Hyatt";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jwiegley ];
  };
}
