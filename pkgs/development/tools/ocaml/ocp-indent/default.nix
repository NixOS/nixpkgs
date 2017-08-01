{ stdenv, fetchzip, ocaml, findlib, ocpBuild, opam, cmdliner }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "3.12.1";
assert versionAtLeast (getVersion cmdliner) "1.0.0";
assert versionAtLeast (getVersion ocpBuild) "1.99.6-beta";

stdenv.mkDerivation rec {

  name = "ocp-indent-${version}";
  version = "1.6.0";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocp-indent/archive/${version}.tar.gz";
    sha256 = "1h9y597s3ag8w1z32zzv4dfk3ppq557s55bnlfw5a5wqwvia911f";
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
