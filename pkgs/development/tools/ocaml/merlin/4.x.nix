{ lib
, substituteAll
, fetchurl
, ocaml
, dune_2
, buildDunePackage
, yojson
, csexp
, result
, dot-merlin-reader
, jq
, menhir
, menhirLib
, menhirSdk
}:

let
  merlinVersion = "4.4";

  hashes = {
    "4.4-411" = "sha256:0chx28098mmnjbnaz5wgzsn82rh1w9dhzqmsykb412cq13msl1q4";
    "4.4-412" = "sha256:18xjpsiz7xbgjdnsxfc52l7yfh22harj0birlph4xm42d14pkn0n";
    "4.4-413" = "sha256:1ilmh2gqpwgr51w2ba8r0s5zkj75h00wkw4az61ssvivn9jxr7k0";
  };

  ocamlVersionShorthand = lib.concatStrings
    (lib.take 2 (lib.splitVersion ocaml.version));

  version = "${merlinVersion}-${ocamlVersionShorthand}";
in

if !lib.hasAttr version hashes
then builtins.throw "merlin ${merlinVersion} is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "merlin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
    sha256 = hashes."${version}";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
  ] ++ lib.optional (!lib.versionAtLeast ocaml.version "4.12")
    # This fixes the test-suite on macOS
    # See https://github.com/ocaml/merlin/pull/1399
    # Fixed in 4.4 for OCaml ≥ 4.12
    ./test.patch
  ;

  useDune2 = true;

  strictDeps = true;

  nativeBuildInputs = [
    menhir
    jq
  ];
  buildInputs = [
    dot-merlin-reader
    yojson
    csexp
    result
    menhirSdk
    menhirLib
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    patchShebangs tests/merlin-wrapper
    dune runtest # filtering with -p disables tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl maintainers.sternenseemann ];
  };
}
