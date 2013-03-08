{ stdenv, fetchgit, fetchurl, ocaml, unzip, ncurses, curl }:

let
  srcs = {
    cudf = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/31910/cudf-0.6.3.tar.gz";
      sha256 = "6e9f1bafe859df85c854679e2904a8172945d2bf2d676c8ae3ecb72fe6de0665";
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
      url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.1.tar.gz";
      sha256 = "ba6388ffc2c15139b0f26330ef6dd922f0ff0f364eee99a3202bf1cd93512b43";
    };
    dose3 = fetchurl {
      url = "https://gforge.inria.fr/frs/download.php/31595/dose3-3.1.2.tar.gz";
      sha256 = "3a07a08345be157c98cb26021d7329c72c2b95c99cfdff79887690656ec9f1a3";
    };
    cmdliner = fetchurl {
      url = "http://erratique.ch/software/cmdliner/releases/cmdliner-0.9.3.tbz";
      sha256 = "5421559aa12b4debffef947f7e1039c22e9dffd87a4aa68445a687a20764ae81";
    };
    opam = fetchurl {
      url = "https://github.com/OCamlPro/opam/archive/0.9.5.zip";
      sha256 = "2ec706330a3283b4d057abc562c6078351988d0ae98ad507fe51cae598b43afd";
    };
  };
in
stdenv.mkDerivation rec {
  name = "opam-0.9.5";

  buildInputs = [unzip curl ncurses ocaml];

  src = srcs.opam;

  postUnpack = ''
  ln -sv ${srcs.cudf} $sourceRoot/src_ext/${srcs.cudf.name}
  ln -sv ${srcs.extlib} $sourceRoot/src_ext/${srcs.extlib.name}
  ln -sv ${srcs.ocaml_re} $sourceRoot/src_ext/${srcs.ocaml_re.name}
  ln -sv ${srcs.ocamlgraph} $sourceRoot/src_ext/${srcs.ocamlgraph.name}
  ln -sv ${srcs.dose3} $sourceRoot/src_ext/${srcs.dose3.name}
  ln -sv ${srcs.cmdliner} $sourceRoot/src_ext/${srcs.cmdliner.name}
  '';

  makeFlags = ["HOME=$(TMPDIR)"];

  doCheck = false;

  meta = {
    description = "A package manager for ocaml";
    platforms = stdenv.lib.platforms.all;
  };
}
