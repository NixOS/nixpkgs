{ stdenv, fetchzip, ocaml, findlib, ocpBuild, ocpIndent, opam, cmdliner, ncurses, re, lambdaTerm, libev }:

let inherit (stdenv.lib) getVersion versionAtLeast optional; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";
assert versionAtLeast (getVersion ocpIndent) "1.4.2";

let version = "1.1.1"; in

stdenv.mkDerivation {

  name = "ocp-index-${version}";

  src = fetchzip {
    url = "http://github.com/OCamlPro/ocp-index/archive/${version}.tar.gz";
    sha256 = "173lqbyivwv1zf9ifpxa9f8m2y3kybzs3idrwyzy824ixdqv2fww";
  };

  buildInputs = [ ocaml findlib ocpBuild opam cmdliner ncurses re libev ]
  ++ optional (versionAtLeast (getVersion lambdaTerm) "1.7") lambdaTerm;
  propagatedBuildInputs = [ ocpIndent ];

  createFindlibDestdir = true;

  preBuild = "export TERM=xterm";
  postInstall = "mv $out/lib/{ocp-index,ocaml/${getVersion ocaml}/site-lib/}";

  meta = {
    homepage = http://typerex.ocamlpro.com/ocp-index.html;
    description = "A simple and light-weight documentation extractor for OCaml";
    license = stdenv.lib.licenses.lgpl3;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
