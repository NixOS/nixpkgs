{ stdenv, fetchurl, makeWrapper, ncurses, ocamlPackages, graphviz
, ltl2ba, coq, alt-ergo, why3, autoconf
}:

let
  mkocamlpath = p: "${p}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib";
  ocamlpath = "${mkocamlpath ocamlPackages.apron}:${mkocamlpath ocamlPackages.mlgmpidl}";
in

stdenv.mkDerivation rec {
  name    = "frama-c-${version}";
  version = "20170501";
  slang   = "Phosphorus";

  src = fetchurl {
    url    = "http://frama-c.com/download/frama-c-${slang}-${version}.tar.gz";
    sha256 = "16bccacms3n4rfpsxdxpdf24bk0hwrnzdpa2pbr6s847li73hkv1";
  };

  why2 = fetchurl {
    url    = "http://why.lri.fr/download/why-2.37.tar.gz";
    sha256 = "00xr8aq6zwln0ccfs1ng610j70r6ia6wqdyaqs9iqibqfa1scr3m";
  };

  nativeBuildInputs = [ autoconf makeWrapper ];

  buildInputs = with ocamlPackages; [
    ncurses ocaml findlib alt-ergo ltl2ba ocamlgraph
    lablgtk coq graphviz zarith why3 apron camlp4
  ];


  # Experimentally, the build segfaults with high core counts
  enableParallelBuilding = false;

  unpackPhase = ''
    tar xf $src
    tar xf $why2
  '';

  buildPhase = ''
    cd frama*
    ./configure --prefix=$out
    # It is not parallel safe
    make
    make install
    cd ../why*
    FRAMAC=$out/bin/frama-c ./configure --prefix=$out
    make
    make install
    for p in $out/bin/frama-c{,-gui};
    do
      wrapProgram $p --prefix OCAMLPATH ':' ${ocamlpath}
    done
  '';

  # Enter frama-c directory before patching
  prePatch = ''cd frama*'';
  patches = [ ./dynamic.diff ];
  postPatch = ''
    # strip absolute paths to /usr/bin
    for file in ./configure ./share/Makefile.common ./src/*/configure; do #*/
      substituteInPlace $file  --replace '/usr/bin/' ""
    done

    substituteInPlace ./src/plugins/aorai/aorai_register.ml --replace '"ltl2ba' '"${ltl2ba}/bin/ltl2ba'

    cd ../why*

    substituteInPlace ./Makefile.in --replace '-warn-error A' '-warn-error A-3'    
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
    description = "An extensible and collaborative platform dedicated to source-code analysis of C software";
    homepage    = http://frama-c.com/;
    license     = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice amiddelk ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
