{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "lsp-unstable";
  version = "2020-07-08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocaml-lsp";
    rev = "61686edf88b8f893862f9aa152be64e17c92295f";
    sha256 = "0qgrsrydf6wimy9hrw7b54zwwrg92fr60r6yf3z4ilbrj4nl5xq4";
    fetchSubmodules = true;
  };

  buildInputs = [ cppo yojson ppx_yojson_conv_lib stdlib-shims menhir dune-build-info ];

  buildPhase = ''
    dune build @install
  '';

  installPhase = ''
    dune install --prefix=$out --sections bin
  '';

  meta = with lib; {
    description = "OCaml Language Server Protocol implementation";
    homepage = "https://github.com/ocaml/ocaml-lsp";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
  };
}
