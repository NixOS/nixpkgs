{stdenv, fetchurl, ocaml, findlib, yojson, menhir
, withEmacsMode ? false, emacs}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

stdenv.mkDerivation {

  name = "merlin-2.1";

  src = fetchurl {
    url = https://github.com/the-lambda-church/merlin/archive/v2.1.tar.gz;
    sha256 = "0rk5ffhr69wbhr50ixgw1vnv0wkhxwh1z3cpbcwkm72cnac74nj6";
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
