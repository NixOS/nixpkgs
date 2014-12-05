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

  # The supplied installer uses opam-installer which breaks when run
  # normally since it tries to `mkdir $HOME`. However, we can use
  # `opam-installer --script` to get the shell script that performs only
  # the installation and just run that. Furthermore, we do the same that is
  # done by pkgs/development/ocaml-modules/react and rename the paths meant
  # for opam-installer so that they are in line with the other OCaml
  # libraries in Nixpkgs.
  installPhase = ''
    opam-installer --script --prefix=$out ocp-indent.install \
    | sed s!lib/ocp-indent!lib/ocaml/${getVersion ocaml}/site-lib/ocp-indent! \
    | sh
  '';

  meta = with stdenv.lib; {
    homepage = "http://typerex.ocamlpro.com/ocp-indent.html";
    description = "A customizable tool to indent OCaml code";
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
