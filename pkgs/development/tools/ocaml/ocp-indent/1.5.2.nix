{ stdenv, fetchzip, ocaml, findlib, ocpBuild, opam, cmdliner }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";
assert versionAtLeast "0.9.8" (getVersion cmdliner);

stdenv.mkDerivation {

  name = "ocp-indent-1.5.2";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/1.5.2.tar.gz";
    sha256 = "0ynv2yhm7akpvqp72pdabhddwr352s1k85q8m1khsvspgg1mkiqz";
  };

  nativeBuildInputs = [ ocpBuild opam ];

  buildInputs = [ ocaml findlib cmdliner ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./install.sh";

  postInstall = ''
    mv $out/lib/{ocp-indent,ocaml/${getVersion ocaml}/site-lib/}
  '';

  meta = with stdenv.lib; {
    homepage = "http://typerex.ocamlpro.com/ocp-indent.html";
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
