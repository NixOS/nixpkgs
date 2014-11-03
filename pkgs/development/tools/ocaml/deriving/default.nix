{stdenv, fetchurl, zlib, ocaml, findlib, ncurses
, versionedDerivation, unzip
, version ?
    let match = {
      "ocaml-3.10.0" = "for-3.10.0";
      "ocaml-3.12.1" = "for-3.12.1";
    }; in stdenv.lib.maybeAttr ocaml.name (throw "no matching source of ocaml-deriving for ocaml version: ${ocaml.name}") match
}:

/*
Usage example:

== main.ml ==
type t = | A | B
  deriving (Show)

print_string (Show.show<t> (A));;
==

ocamlopt -pp $out/bin/deriving -I $d/lib -I $d/syntax nums.cmxa show.cmx main.ml
*/

versionedDerivation "ocaml-deriving" version {

  "for-3.10.0" = {
    name = "deriving-0.1.1a";
      # ocaml: 3.10.0
    src = fetchurl {
      url = https://deriving.googlecode.com/files/deriving-0.1.1a.tar.gz;
      sha256 = "0ppmqhc23kccfjn3cnd9n205ky627ni8f5djf8sppmc3lc1m97mb";
    };
  };

  "for-3.12.1" = {
    name = "deriving-git20100903";

    # https://github.com/jaked/deriving
    src = fetchurl {
      name = "for-3.12.0.zip";
      url = https://codeload.github.com/jaked/deriving/zip/c7b9cea3eb4bbfb9e09673faf725f70247c9df78;
      sha256 = "1zrmpqb5lsjmizqs68czmfpsbz9hz30pf97w11kkby175hhj84gi";
    };

    buildInputs = [ unzip ];
  };

}
{
  buildInputs = [ocaml findlib];

  installPhase = ''
    # not all tests compile !?
    # (cd tests; make)

    mkdir -p $out/bin
    cp -a lib $out/
    cp -a syntax $out

    # this allows -pp deriving
    ln -s $out/syntax/deriving $out/bin/deriving
  '';

  meta = {
    homepage = "https://code.google.com/p/deriving/source/checkout";
    description = "A library of cryptographic primitives for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
