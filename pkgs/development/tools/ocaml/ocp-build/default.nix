{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ocaml,
  findlib,
  ncurses,
  cmdliner_1_0,
  re,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocp-build";
  version = "1.99.21";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = "v${version}";
    sha256 = "1641xzik98c7xnjwxpacijd6d9jzx340fmdn6i372z8h554jjlg9";
  };

  patches = [
    # Fix compilation with OCaml 4.12
    (fetchpatch {
      url = "https://github.com/OCamlPro/ocp-build/commit/104e4656ca6dba9edb03b62539c9f1e10abcaae8.patch";
      sha256 = "0sbyi4acig9q8x1ky4hckfg5pm2nad6zasi51ravaf1spgl148c2";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  buildInputs = [
    cmdliner_1_0
    re
  ];
  propagatedBuildInputs = [ ncurses ];
  preInstall = "mkdir -p $out/bin";

  meta = with lib; {
    description = "Build tool for OCaml";
    longDescription = ''
      ocp-build is a build system for OCaml application, based on simple
      descriptions of packages. ocp-build combines the descriptions of
      packages, and optimize the parallel compilation of files depending on
      the number of cores and the automatically-inferred dependencies
      between source files.
    '';
    homepage = "https://www.typerex.org/ocp-build.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.jirkamarsik ];
    mainProgram = "ocp-build";
    broken = lib.versionAtLeast ocaml.version "5.0";
    inherit (ocaml.meta) platforms;
  };
}
