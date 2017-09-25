{ stdenv, fetchzip, ocaml, findlib, yojson, lib
, withEmacsMode ? false, emacs }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

let
  version = "3.0.2";
in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml/merlin/archive/v${version}.tar.gz";
    sha256 = "0lcgafs5ip8vhvrp1d7yv6mzjsirmayd83cj4wwq6zxcrl7yv4x8";
  };

  buildInputs = [ ocaml findlib yojson ]
    ++ stdenv.lib.optional withEmacsMode emacs;

  preConfigure = "mkdir -p $out/bin";
  prefixKey = "--prefix ";
  configureFlags = stdenv.lib.optional withEmacsMode "--enable-compiled-emacs-mode";

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = http://the-lambda-church.github.io/merlin/;
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
