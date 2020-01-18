{ stdenv, fetchFromGitHub, ocamlPackages, CoreServices, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.116.1";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "flow";
    rev    = "refs/tags/v${version}";
    sha256 = "19j2zw8ajky04d2ayfzj99yz805igip1ql3i4v7bblamc8sk38cn";
  };

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  buildInputs = (with ocamlPackages; [ ocaml findlib ocamlbuild dtoa core_kernel sedlex_2 ocaml_lwt lwt_log lwt_ppx ppx_deriving ppx_gen_rec ppx_tools_versioned visitors wtf8 ocaml-migrate-parsetree ])
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  patches = [
    # Fix List.compare labeled argument. Remove with the next release
    (fetchpatch {
      url = "https://github.com/facebook/flow/commit/d061b38042327d8241fb6dec7c8307c86b2f23d6.patch";
      sha256 = "1rmkb1zldgm2y2n32nm2xd8c7wk3hccsbljjz6bm6a0yixa6w77l";
    })
  ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = https://flow.org/;
    changelog = "https://github.com/facebook/flow/releases/tag/v${version}";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ marsam puffnfresh ];
  };
}
