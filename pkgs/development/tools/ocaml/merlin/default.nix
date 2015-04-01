{ stdenv, fetchzip, ocaml, findlib, yojson, menhir
, withEmacsMode ? false, emacs }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

let version = "2.1.2"; in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/the-lambda-church/merlin/archive/v${version}.tar.gz";
    sha256 = "0l6s4bvspjl1l26bf33xf4k5imdzryas15s1isn6998aiakxq20n";
  };

  buildInputs = [ ocaml findlib yojson menhir ]
    ++ stdenv.lib.optional withEmacsMode emacs;

  preConfigure = "mkdir -p $out/bin";
  prefixKey = "--prefix ";
  configureFlags = stdenv.lib.optional withEmacsMode "--enable-compiled-emacs-mode";

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "http://the-lambda-church.github.io/merlin/";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
