{ stdenv, fetchzip, ocaml, findlib, ocpBuild, opam, cmdliner }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion cmdliner) "1.0.0";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";

stdenv.mkDerivation rec {

  name = "ocp-indent-${version}";
  version = "1.6.1";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "0rcaa11mjqka032g94wgw9llqpflyk3ywr3lr6jyxbh1rjvnipnw";
  };

  nativeBuildInputs = [ ocpBuild opam ];
  buildInputs = [ ocaml findlib cmdliner ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./install.sh";

  postInstall = ''
    mv $out/lib/{ocp-indent,ocaml/${getVersion ocaml}/site-lib/}
  '';

  meta = with stdenv.lib; {
    homepage = http://typerex.ocamlpro.com/ocp-indent.html;
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
