{ lib, stdenv, fetchFromGitHub, ocamlPackages, CoreServices }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.174.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "sha256-lfj6KyB9QYvUy4Ybo8f30omAg4K/jT5MEERJPm0aJ7U=";
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
