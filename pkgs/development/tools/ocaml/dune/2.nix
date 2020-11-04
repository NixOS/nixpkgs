{ stdenv, fetchurl, ocaml, findlib, fetchpatch }:

if stdenv.lib.versionOlder ocaml.version "4.08"
then throw "dune is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "2.7.1";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "0pcjf209gynjwipnpplaqyvyivnawqiwhvqnivhkybisicpqyln3";
  };

  buildInputs = [ ocaml findlib ];

  buildFlags = "release";

  patches = [
    # Fix setup.ml configure path. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/ocaml/dune/commit/8a3d7f2f2015b71384caa07226d1a89dba9d6c25.patch";
      sha256 = "0dw4q10030h9xcdlxw2vp7qm0hd2qpkb98rir5d55m9vn65w8j28";
    })
  ];

  dontAddPrefix = true;

  installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    changelog = "https://github.com/ocaml/dune/releases/tag/${version}";
    maintainers = [ stdenv.lib.maintainers.vbgl stdenv.lib.maintainers.marsam ];
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
