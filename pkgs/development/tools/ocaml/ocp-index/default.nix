{ stdenv, fetchFromGitHub, ocaml, findlib, ocpBuild, ocpIndent, opam, cmdliner, ncurses, re, lambdaTerm, libev }:

let inherit (stdenv.lib) getVersion versionAtLeast optional; in

assert versionAtLeast (getVersion ocaml) "4";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";
assert versionAtLeast (getVersion ocpIndent) "1.4.2";

let
  version = "1.1.4";
  srcs = {
    "4.03.0" = {
      rev = "${version}-4.03";
      sha256 = "0c6s5radwyvxf9hrq2y9lirk72z686k9yzd0vgzy98yrrp1w56mv";
    };
    "4.02.3" = {
      rev = "${version}-4.02";
      sha256 = "057ss3lz754b2pznkb3zda5h65kjgqnvabvfqwqcz4qqxxki2yc8";
    };
    "4.01.0" = {
      rev = "${version}";
      sha256 = "106bnc8jhmjnychcl8k3gl9n6b50bc66qc5hqf1wkbkk9kz4vc9d";
    };
  };

  src = fetchFromGitHub ({
    owner = "OCamlPro";
    repo = "ocp-index";
  } // srcs."${ocaml.version}");
in

stdenv.mkDerivation {

  name = "ocp-index-${version}";

  inherit src;

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
