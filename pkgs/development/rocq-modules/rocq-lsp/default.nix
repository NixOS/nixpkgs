{
  lib,
  mkRocqDerivation,
  rocq-core,
  makeWrapper,
  version ? null,
}:

mkRocqDerivation rec {
  pname = "rocq-lsp";
  owner = "rocq-community";
  namePrefix = [ ];

  useDune = true;
  # Upstream still uses coq-lsp as the Dune package and executable name.
  opam-name = "coq-lsp";

  release."0.2.3+9.0".hash = "sha256-eZMM4gYRXQroEIKz6XlffyHNYryEF5dIeIoVbEulh6M=";
  release."0.2.4+9.0".hash = "sha256-ICPdNxJODNqmUErdTkNk7s52MRuINWLbAPm0rmXFW18=";
  release."0.2.4+9.1".hash = "sha256-HNHA2vbX70oZkd4QtbP28UbTRXatqxJdxw1OWDVDE8U=";
  release."0.2.5+9.0".hash = "sha256-nbMf7xziBYoBH0F8YBUEybCHSdsaOxlqXnyngeQNg3c=";
  release."0.2.5+9.1".hash = "sha256-PzIgo15zI3JjibT8GzyHdTwofd3IF6eRmUc47NveH70=";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.rocq-version [
      (case (isEq "9.0") "0.2.5+9.0")
      (case (isEq "9.1") "0.2.5+9.1")
    ] null;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    dune install -p coq-lsp --prefix=$out --libdir $OCAMLFIND_DESTDIR
    for program in $out/bin/*; do
      wrapProgram "$program" --prefix OCAMLPATH : "$OCAMLFIND_DESTDIR" --prefix OCAMLPATH : "$OCAMLPATH"
    done
    runHook postInstall
  '';

  propagatedBuildInputs = with rocq-core.ocamlPackages; [
    cmdliner
    dune-build-info
    findlib
    logs
    lwt
    memprof-limits
    menhir
    ppx_deriving
    ppx_deriving_yojson
    ppx_import
    ppx_sexp_conv
    ppx_compare
    ppx_hash
    sexplib
    tyxml
    uri
    yojson
  ];

  meta = {
    description = "Language server for the Rocq Prover";
    homepage = "https://github.com/rocq-community/rocq-lsp";
    changelog = "https://github.com/rocq-community/rocq-lsp/blob/${
      if version != null then version else defaultVersion
    }/CHANGES.md";
    mainProgram = "coq-lsp";
    maintainers = with lib.maintainers; [ alizter ];
    license = lib.licenses.lgpl21Plus;
  };
}
