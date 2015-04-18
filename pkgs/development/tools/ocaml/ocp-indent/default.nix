{ stdenv, fetchurl, ocaml, findlib, ocpBuild, opam, cmdliner }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion ocpBuild) "1.99.3-beta";

stdenv.mkDerivation {

  name = "ocp-indent-1.4.2b";

  src = fetchurl {
    url = "https://github.com/OCamlPro/ocp-indent/archive/1.4.2b.tar.gz";
    sha256 = "1p0n2zcl5kf543x2xlqrz1aa51f0dqal8l392sa41j6wx82j0gpb";
  };

  buildInputs = [ ocaml findlib ocpBuild opam cmdliner ];

  createFindlibDestdir = true;

  postInstall = ''
    mv $out/lib/{ocp-indent,ocaml/${getVersion ocaml}/site-lib/}
  '';

  meta = with stdenv.lib; {
    homepage = "http://typerex.ocamlpro.com/ocp-indent.html";
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
