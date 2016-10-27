{ stdenv, fetchzip, ocaml, findlib, yojson, menhir, lib
, withEmacsMode ? false, emacs }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

let
  version = if lib.versionOlder (lib.getVersion ocaml) "4.02.0"
  then
    "2.3.1"
  else
    "2.5.1";
  hashes = {
    "2.3.1" = "192jamcc7rmvadlqqsjkzsl6hlgwhg9my1qc89fxh1lmd4qdsrpn";
    "2.5.1" = "0p3hqxawp18q43ws6506cnndi49f3gxzmai0x2qch7h42dgh1cb8";
  };
in

stdenv.mkDerivation {

  name = "merlin-${version}";

  src = fetchzip {
    url = "https://github.com/the-lambda-church/merlin/archive/v${version}.tar.gz";
    sha256 = hashes."${version}";
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
