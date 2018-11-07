{ stdenv, fetchFromGitHub, ocamlPackages, cf-private, CoreServices }:

stdenv.mkDerivation rec {
  version = "0.85.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "flow";
    rev    = "refs/tags/v${version}";
    sha256 = "0kci017bl4ihq89zpwlgdlwzv7kili8146940kyar5v66kgf7xsh";
  };

  installPhase = ''
    install -Dm755 -t $out/bin bin/flow
  '';

  buildInputs = (with ocamlPackages; [ ocaml findlib ocamlbuild dtoa core_kernel sedlex ocaml_lwt lwt_log lwt_ppx ppx_deriving ppx_gen_rec ppx_tools_versioned visitors wtf8 ])
    ++ stdenv.lib.optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = https://flow.org/;
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
