{ stdenv, fetchFromGitHub, ocamlPackages, CoreServices, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.114.0";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "flow";
    rev    = "refs/tags/v${version}";
    sha256 = "1dkp3v898b5vd0a9fl5xknwbbqv23v0icqml8ypyhzrv6wz5qiy3";
  };

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  buildInputs = (with ocamlPackages; [ ocaml findlib ocamlbuild dtoa core_kernel sedlex ocaml_lwt lwt_log lwt_ppx ppx_deriving ppx_gen_rec ppx_tools_versioned visitors wtf8 ocaml-migrate-parsetree ])
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  patches = [
    # Fix List.compare labeled argument. Remove when https://github.com/facebook/flow/pull/8191 is merged
    (fetchpatch {
      url = "https://github.com/facebook/flow/commit/1625664ec7290d4128587d96cb878571751f8881.patch";
      sha256 = "18fan0d2xa6z4ilbr7ha3vhnfqlr2s6mb02sgpv8ala99b0mcgmn";
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
