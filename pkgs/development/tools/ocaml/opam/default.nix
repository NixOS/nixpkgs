{ stdenv, fetchgit, fetchurl, ocaml, unzip, ncurses, curl }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12.1";

let
  srcs = {
    cudf = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/33593/cudf-0.7.tar.gz";
      sha256 = "92c8a9ed730bbac73f3513abab41127d966c9b9202ab2aaffcd02358c030a701";
    };
    extlib = fetchurl {
      url = "http://ocaml-extlib.googlecode.com/files/extlib-1.5.3.tar.gz";
      sha256 = "c095eef4202a8614ff1474d4c08c50c32d6ca82d1015387785cf03d5913ec021";
    };
    ocaml_re = fetchurl {
      url = "https://github.com/ocaml/ocaml-re/archive/ocaml-re-1.2.0.tar.gz";
      sha256 = "a34dd9d6136731436a963bbab5c4bbb16e5d4e21b3b851d34887a3dec451999f";
    };
    ocamlgraph = fetchurl {
      url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.5.tar.gz";
      sha256 = "d167466435a155c779d5ec25b2db83ad851feb42ebc37dca8ffa345ddaefb82f";
    };
    dose3 = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/file/34277/dose3-3.3.tar.gz";
      sha256 = "8dc4dae9b1a81bb3a42abb283df785ba3eb00ade29b13875821c69f03e00680e";
    };
    cmdliner = fetchurl {
      url = "http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.7.tbz";
      sha256 = "9c19893cffb5d3c3469ee0cce85e3eeeba17d309b33b9ace31aba06f68f0bf7a";
    };
    uutf = fetchurl {
      url = "http://erratique.ch/software/uutf/releases/uutf-0.9.3.tbz";
      sha256 = "1f364f89b1179e5182a4d3ad8975f57389d45548735d19054845e06a27107877";
    };
    jsonm = fetchurl {
      url = "http://erratique.ch/software/jsonm/releases/jsonm-0.9.1.tbz";
      sha256 = "3fd4dca045d82332da847e65e981d8b504883571d299a3f7e71447d46bc65f73";
    };
    opam = fetchurl {
      url = "https://github.com/ocaml/opam/archive/1.2.2.zip";
      sha256 = "1fxd5axlh9f3jb47y9paa9ld78qwcyp7pv3m60k401ym1dps32jk";
    };
  };
in stdenv.mkDerivation rec {
  name = "opam-${version}";
  version = "1.2.2";

  buildInputs = [ unzip curl ncurses ocaml ];

  src = srcs.opam;

  postUnpack = ''
    ln -sv ${srcs.cudf} $sourceRoot/src_ext/${srcs.cudf.name}
    ln -sv ${srcs.extlib} $sourceRoot/src_ext/${srcs.extlib.name}
    ln -sv ${srcs.ocaml_re} $sourceRoot/src_ext/${srcs.ocaml_re.name}
    ln -sv ${srcs.ocamlgraph} $sourceRoot/src_ext/${srcs.ocamlgraph.name}
    ln -sv ${srcs.dose3} $sourceRoot/src_ext/${srcs.dose3.name}
    ln -sv ${srcs.cmdliner} $sourceRoot/src_ext/${srcs.cmdliner.name}
    ln -sv ${srcs.uutf} $sourceRoot/src_ext/${srcs.uutf.name}
    ln -sv ${srcs.jsonm} $sourceRoot/src_ext/${srcs.jsonm.name}
  '';

  preConfigure = ''
    substituteInPlace ./src_ext/Makefile --replace "%.stamp: %.download" "%.stamp:"
  '';

  postConfigure = "make lib-ext";

  # Dirty, but apparently ocp-build requires a TERM
  makeFlags = ["TERM=screen"];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A package manager for OCaml";
    homepage = http://opam.ocamlpro.com/;
    maintainers = [ maintainers.henrytill ];
    platforms = platforms.all;
  };
}
