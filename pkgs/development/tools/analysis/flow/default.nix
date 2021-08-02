{ lib, stdenv, fetchFromGitHub, ocamlPackages, CoreServices }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.156.0";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "flow";
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-aV5qcXxNLljeM3MrXg8ptAST8ARCb3kR83oy5G9fbak=";
  };

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  buildInputs = (with ocamlPackages; [ ocaml findlib ocamlbuild ocaml-migrate-parsetree-2 dtoa core_kernel sedlex_2 ocaml_lwt lwt_log lwt_ppx ppx_deriving ppx_gen_rec visitors wtf8 ])
    ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A static type checker for JavaScript";
    homepage = "https://flow.org/";
    changelog = "https://github.com/facebook/flow/raw/v${version}/Changelog.md";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ marsam puffnfresh ];
  };
}
