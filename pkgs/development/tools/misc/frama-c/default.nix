# Note on a potential dependency-bloat:
# Frama-c ships with several plugins that have dependencies on other
# software. Not providing the dependencies has as effect that certain
# plugins will not be available.
# I've included the dependencies that are well-supported by nixpkgs
# and seem useful in general. Not included are:
#   alt-ergo, ltl2ba, otags, why-dp

{ stdenv, fetchurl, ncurses, ocamlPackages, coq, graphviz }:

let

  version = "20111001";
  sha256 = "8afad848321c958fab265045cd152482e77ce7c175ee7c9af2d4bec57a1bc671";

in stdenv.mkDerivation {
  name = "frama-c-${version}";

  src = fetchurl {
    url = "http://frama-c.com/download/frama-c-Nitrogen-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = with ocamlPackages; [
    ncurses ocaml findlib ocamlgraph
    lablgtk coq graphviz  # optional dependencies
  ];

  patches = [
    # this patch comes from the debian frama-c package, and was
    # posted on the frama-c issue tracker.
    ./0007-Port-to-OCamlgraph-1.8.2.patch
  ];

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
      --replace '1.8)' '*)'
    substituteInPlace ./Makefile --replace '+lablgtk2' "$LABLGTK_HOME" \
      --replace '$(patsubst +%,.,$(INCLUDES) $(GUI_INCLUDES))' \
                '$(patsubst /%,.,$(patsubst +%,.,$(INCLUDES) $(GUI_INCLUDES)))'
  '';

  meta = {
    description = "Frama-C is an extensible tool for source-code analysis of C software";

    homepage = http://frama-c.com/;
    license = "GPLv2";

    maintainers = [ stdenv.lib.maintainers.amiddelk ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
