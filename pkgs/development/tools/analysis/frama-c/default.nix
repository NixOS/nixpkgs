{ stdenv, fetchurl, ncurses, ocamlPackages, graphviz
, ltl2ba, coq, alt-ergo, why3 }:

stdenv.mkDerivation rec {
  name    = "frama-c-${version}";
  version = "20140301";
  slang   = "Neon";

  src = fetchurl {
    url    = "http://frama-c.com/download/frama-c-${slang}-${version}.tar.gz";
    sha256 = "0ca7ky7vs34did1j64v6d8gcp2irzw3rr5qgv47jhmidbipn1865";
  };

  why2 = fetchurl {
    url    = "http://why.lri.fr/download/why-2.34.tar.gz";
    sha256 = "1335bhq9v3h46m8aba2c5myi9ghm87q41in0m15xvdrwq5big1jg";
  };

  buildInputs = with ocamlPackages; [
    ncurses ocaml findlib alt-ergo ltl2ba ocamlgraph
    lablgtk coq graphviz zarith why3 zarith
  ];


  enableParallelBuilding = true;
  configureFlags = [ "--disable-local-ocamlgraph" ];

  unpackPhase = ''
    tar xf $src
    tar xf $why2
  '';

  buildPhase = ''
    cd frama*
    ./configure --prefix=$out
    make -j$NIX_BUILD_CORES
    make install
    cd ../why*
    FRAMAC=$out/bin/frama-c ./configure --prefix=$out
    make
    make install
  '';


  # Taken from Debian Sid
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=746091
  patches = ./0004-Port-to-OCamlgraph-1.8.5.patch;

  # Enter frama-c directory before patching
  prePatch = ''cd frama*'';
  postPatch = ''
    # strip absolute paths to /usr/bin
    for file in ./configure ./share/Makefile.common ./src/*/configure; do
      substituteInPlace $file  --replace '/usr/bin/' ""
    done

    # find library paths
    OCAMLGRAPH_HOME=`ocamlfind query ocamlgraph`
    LABLGTK_HOME=`ocamlfind query lablgtk2`

    # patch search paths
    # ensure that the tests against the ocamlgraph version succeeds
    # filter out the additional search paths from ocamldep
    substituteInPlace ./configure \
      --replace '$OCAMLLIB/ocamlgraph' "$OCAMLGRAPH_HOME" \
      --replace '$OCAMLLIB/lablgtk2' "$LABLGTK_HOME" \
      --replace '+ocamlgraph' "$OCAMLGRAPH_HOME" \
    substituteInPlace ./Makefile --replace '+lablgtk2' "$LABLGTK_HOME" \
      --replace '$(patsubst +%,.,$(INCLUDES) $(GUI_INCLUDES))' \
                '$(patsubst /%,.,$(patsubst +%,.,$(INCLUDES) $(GUI_INCLUDES)))'

    substituteInPlace ./src/aorai/aorai_register.ml --replace '"ltl2ba' '"${ltl2ba}/bin/ltl2ba'

    cd ../why*
    substituteInPlace ./frama-c-plugin/Makefile --replace 'shell frama-c' "shell $out/bin/frama-c"
    substituteInPlace ./jc/jc_make.ml --replace ' why-dp '       " $out/bin/why-dp "
    substituteInPlace ./jc/jc_make.ml --replace "?= why@\n"      "?= $out/bin/why@\n"
    substituteInPlace ./jc/jc_make.ml --replace ' gwhy-bin@'     " $out/bin/gwhy-bin@"
    substituteInPlace ./jc/jc_make.ml --replace ' why3 '         " ${why3}/bin/why3 "
    substituteInPlace ./jc/jc_make.ml --replace ' why3ide '      " ${why3}/bin/why3ide "
    substituteInPlace ./jc/jc_make.ml --replace ' why3replayer ' " ${why3}/bin/why3replayer "
    substituteInPlace ./jc/jc_make.ml --replace ' why3ml '       " ${why3}/bin/why3ml "
    substituteInPlace ./jc/jc_make.ml --replace ' coqdep@'       " ${coq}/bin/coqdep@"
    substituteInPlace ./jc/jc_make.ml --replace 'coqc'           " ${coq}/bin/coqc"
    substituteInPlace ./frama-c-plugin/register.ml --replace ' jessie ' " $out/bin/jessie "
    cd ..
  '';

  meta = {
    description = "Frama-C is an extensible tool for source-code analysis of C software";
    homepage    = http://frama-c.com/;
    license     = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice amiddelk ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
