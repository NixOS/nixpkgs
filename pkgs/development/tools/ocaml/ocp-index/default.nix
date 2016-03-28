{ stdenv, fetchurl, fetchzip, ocaml, findlib, ocpBuild, ocpIndent, opam, cmdliner, ncurses, re, lambdaTerm, libev }:

let inherit (stdenv.lib) getVersion versionAtLeast optional; in

assert versionAtLeast (getVersion ocaml) "4";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";
assert versionAtLeast (getVersion ocpIndent) "1.4.2";

let
  version = "1.1.2";
  patch402 = fetchurl {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ocp-index/ocp-index.1.1.2/files/ocaml.4.02.patch;
    sha256 = "1wcpn2pv7h8ia3ybmzdlm8v5hfvq1rgmlj02wwj0yh3vqjvxqvsm";
  };
in

stdenv.mkDerivation {

  name = "ocp-index-${version}";

  src = fetchzip {
    url = "http://github.com/OCamlPro/ocp-index/archive/${version}.tar.gz";
    sha256 = "0cz0bz5nisc5r23b1w07q2bl489gd09mg8rp9kyq9m6rj669b18l";
  };

  patches = optional (versionAtLeast (getVersion ocaml) "4.02") patch402;

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
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
