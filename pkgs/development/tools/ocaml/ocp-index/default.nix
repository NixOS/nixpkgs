{ stdenv, fetchFromGitHub, fetchpatch, ocaml, findlib, ocpBuild, ocpIndent, opam, cmdliner, ncurses, re, lambdaTerm, libev }:

let inherit (stdenv.lib) getVersion versionAtLeast optional; in

assert versionAtLeast (getVersion ocaml) "4";
assert versionAtLeast (getVersion ocpBuild) "1.99.13-beta";
assert versionAtLeast (getVersion ocpIndent) "1.4.2";

let
  version = "1.1.5";
in

stdenv.mkDerivation {

  name = "ocp-index-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    rev = version;
    sha256 = "0gir0fm8mq609371kmwpsqfvpfx2b26ax3f9rg5fjf5r0bjk9pqd";
  };

  patches = [ (fetchpatch {
    url = https://github.com/OCamlPro/ocp-index/commit/618872a0980d077857a63d502eadbbf0d1b05c0f.diff;
    sha256 = "07snnydczkzapradh1c22ggv9vaff67nc36pi3218azb87mb1p7z";
  }) ];

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
