{ lib, stdenv, fetchurl, makeWrapper, writeText
, autoconf, ncurses, graphviz, doxygen
, ocamlPackages, ltl2ba, coq, why3,
}:

let
  mkocamlpath = p: "${p}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib";
  runtimeDeps = with ocamlPackages; [
    apron
    biniou
    camlzip
    easy-format
    menhir
    mlgmpidl
    num
    ocamlgraph
    why3
    yojson
    zarith
  ];
  ocamlpath = lib.concatMapStringsSep ":" mkocamlpath runtimeDeps;
in

stdenv.mkDerivation rec {
  pname = "frama-c";
  version = "20.0";
  slang   = "Calcium";

  src = fetchurl {
    url    = "http://frama-c.com/download/frama-c-${version}-${slang}.tar.gz";
    sha256 = "03dvn162djylj2skmk6vv75gh87mm4s5cspkzcrlm5x0rlla2yqn";
  };

  preConfigure = lib.optionalString stdenv.cc.isClang "configureFlagsArray=(\"--with-cpp=clang -E -C\")";

  nativeBuildInputs = [ autoconf makeWrapper ];

  buildInputs = with ocamlPackages; [
    ncurses ocaml findlib ltl2ba ocamlgraph yojson menhir camlzip
    lablgtk coq graphviz zarith apron why3 mlgmpidl doxygen
  ];

  enableParallelBuilding = true;

  fixupPhase = ''
    for p in $out/bin/frama-c{,-gui};
    do
      wrapProgram $p --prefix OCAMLPATH ':' ${ocamlpath}
    done
  '';

  # Allow loading of external Frama-C plugins
  setupHook = writeText "setupHook.sh" ''
    addFramaCPath () {
      if test -d "''$1/lib/frama-c/plugins"; then
        export FRAMAC_PLUGIN="''${FRAMAC_PLUGIN}''${FRAMAC_PLUGIN:+:}''$1/lib/frama-c/plugins"
        export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib/frama-c/plugins"
      fi

      if test -d "''$1/lib/frama-c"; then
        export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib/frama-c"
      fi

      if test -d "''$1/share/frama-c/"; then
        export FRAMAC_EXTRA_SHARE="''${FRAMAC_EXTRA_SHARE}''${FRAMAC_EXTRA_SHARE:+:}''$1/share/frama-c"
      fi

    }

    addEnvHooks "$targetOffset" addFramaCPath
  '';


  meta = {
    description = "An extensible and collaborative platform dedicated to source-code analysis of C software";
    homepage    = http://frama-c.com/;
    license     = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice amiddelk ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
