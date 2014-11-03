{ stdenv, fetchurl, ocaml, curl, ncurses, makeWrapper }:

# Opam 1.2.0 only works with ocaml >= 4.01 according to ./configure
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation {
  name = "opam-1.2.0";

  buildInputs = [ ocaml curl makeWrapper ];

  src = fetchurl {
    url = https://github.com/ocaml/opam/archive/1.2.0.tar.gz;
    sha256 = "0qcwi8z7ny69carz5rcnhz58cj9sy7b1yw2xij548y6c4z800j7n";
  };

  srcExt =
    [ (fetchurl {
        url = "http://ocaml-extlib.googlecode.com/files/extlib-1.5.3.tar.gz";
        sha256 = "c095eef4202a8614ff1474d4c08c50c32d6ca82d1015387785cf03d5913ec021";
      })

      (fetchurl {
        url = https://github.com/ocaml/ocaml-re/archive/ocaml-re-1.2.0.tar.gz;
        sha256 = "a34dd9d6136731436a963bbab5c4bbb16e5d4e21b3b851d34887a3dec451999f";
      })

      (fetchurl {
        url = http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.4.tbz;
        sha256 = "1vv95q76lgnk3z23fpmvz2w1z96dh15373x7jxzc0klqzln5xdpc";
      })

      (fetchurl {
        url = http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.5.tar.gz;
        sha256 = "0bxqxzd5sd7siz57vhzb8bmiz1ddhgdv49gcsmwwfmd16mj4cryi";
      })

      (fetchurl {
        url = https://gforge.inria.fr/frs/download.php/file/33593/cudf-0.7.tar.gz;
        sha256 = "00d76305h8yhzjpjmaq2jadnr5kx290spaqk6lzwgfhbfgnskj4j";
      })

      (fetchurl {
        url = https://gforge.inria.fr/frs/download.php/file/33677/dose3-3.2.2.tar.gz;
        sha256 = "174hzkggvjrqgzrzf9m6ilndzwsir50882fpjvgd33i9kygih2m3";
      })

      (fetchurl {
        url = http://erratique.ch/software/uutf/releases/uutf-0.9.3.tbz;
        sha256 = "0xvq20knmq25902ijpbk91ax92bkymsqkbfklj1537hpn64lydhz";
      })

      (fetchurl {
        url = http://erratique.ch/software/jsonm/releases/jsonm-0.9.1.tbz;
        sha256 = "0wszqrmx8iqlwzvs76fjf4sqh15mv20yjrbyhkd348yq8nhdrm1z";
      })
  ];

  postUnpack = ''
    for s in $srcExt; do
        stripHash $s
        ln -sv $s $sourceRoot/src_ext/$strippedName
    done
  '';

  preBuild = "make lib-ext";

  postInstall = ''
    wrapProgram $out/bin/opam \
        --prefix LIBRARY_PATH ":" "${ncurses}/lib"
  '';

  meta = with stdenv.lib;
    { description = "Source-based package manager for OCaml";
      license     = licenses.lgpl3;
      maintainers = with maintainers; [ orbitz emery ];
      platforms   = platforms.all;
    };
}
