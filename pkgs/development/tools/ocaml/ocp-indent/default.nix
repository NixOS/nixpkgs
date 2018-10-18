{ stdenv, fetchzip, ocaml, findlib, dune, ocp-build, cmdliner }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion cmdliner) "1.0.0";
assert versionAtLeast (getVersion ocp-build) "1.99.6-beta";

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-ocp-indent-${version}";
  version = "1.6.1";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "0rcaa11mjqka032g94wgw9llqpflyk3ywr3lr6jyxbh1rjvnipnw";
  };

  nativeBuildInputs = [ ocp-build ];
  buildInputs = [ ocaml findlib cmdliner ];

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = http://typerex.ocamlpro.com/ocp-indent.html;
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
