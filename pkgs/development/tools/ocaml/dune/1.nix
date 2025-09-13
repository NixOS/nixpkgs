{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "dune";
  version = "1.11.4";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-build-info-${version}.tbz";
    sha256 = "1rkc8lqw30ifjaz8d81la6i8j05ffd0whpxqsbg6dci16945zjvp";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  buildInputs = [ ncurses ];
  strictDeps = true;

  buildFlags = [ "release" ];
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=$(OCAMLFIND_DESTDIR)"
  ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  meta = with lib; {
    homepage = "https://dune.build/";
    description = "Composable build system";
    maintainers = [ maintainers.vbgl ];
    license = licenses.mit;
    broken = lib.versionOlder ocaml.version "4.02" || lib.versionAtLeast ocaml.version "4.12";
    inherit (ocaml.meta) platforms;
  };
}
