{ stdenv, fetchzip, ocaml, findlib, yojson
, withEmacsMode ? false, emacs }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

let
  version = "3.1.0";
in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml/merlin/archive/v${version}.tar.gz";
    sha256 = "1vf0c2mmflp94r8hshb44lsvnfdy03ld6mld2n79cdxr3zl24ci2";
  };

  buildInputs = [ ocaml findlib yojson ]
    ++ stdenv.lib.optional withEmacsMode emacs;

  preConfigure = "mkdir -p $out/bin";
  prefixKey = "--prefix ";
  configureFlags = stdenv.lib.optional withEmacsMode "--enable-compiled-emacs-mode";

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = https://github.com/ocaml/merlin;
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
