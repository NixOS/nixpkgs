{ lib, stdenv, fetchurl, makeWrapper, writeText
, autoconf, ncurses, graphviz, doxygen
, ocamlPackages, ltl2ba, coq, why3
, gdk-pixbuf, wrapGAppsHook
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
  version = "21.1";
  slang   = "Scandium";

  src = fetchurl {
    url    = "http://frama-c.com/download/frama-c-${version}-${slang}.tar.gz";
    sha256 = "0qq0d08dzr0dmdjysiimdqmwlzgnn932vp5kf8lfn3nl45ai09dy";
  };

  preConfigure = lib.optionalString stdenv.cc.isClang "configureFlagsArray=(\"--with-cpp=clang -E -C\")";

  nativeBuildInputs = [ autoconf wrapGAppsHook ];

  buildInputs = with ocamlPackages; [
    ncurses ocaml findlib ltl2ba ocamlgraph yojson menhir camlzip
    lablgtk coq graphviz zarith apron why3 mlgmpidl doxygen
    gdk-pixbuf
  ];

  enableParallelBuilding = true;

  preFixup = ''
     gappsWrapperArgs+=(--prefix OCAMLPATH ':' ${ocamlpath})
  '';

  # Allow loading of external Frama-C plugins
  setupHook = writeText "setupHook.sh" ''
    addFramaCPath () {
      if test -d "''$1/lib/frama-c/plugins"; then
        export FRAMAC_PLUGIN="''${FRAMAC_PLUGIN-}''${FRAMAC_PLUGIN:+:}''$1/lib/frama-c/plugins"
        export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/frama-c/plugins"
      fi

      if test -d "''$1/lib/frama-c"; then
        export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/frama-c"
      fi

      if test -d "''$1/share/frama-c/"; then
        export FRAMAC_EXTRA_SHARE="''${FRAMAC_EXTRA_SHARE-}''${FRAMAC_EXTRA_SHARE:+:}''$1/share/frama-c"
      fi

    }

    addEnvHooks "$targetOffset" addFramaCPath
  '';


  meta = {
    description = "An extensible and collaborative platform dedicated to source-code analysis of C software";
    homepage    = "http://frama-c.com/";
    license     = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice amiddelk ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
