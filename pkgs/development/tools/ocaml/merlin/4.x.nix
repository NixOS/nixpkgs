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
  merlinVersion = "4.5";

  hashes = {
    "4.5-411" = "sha256:05nz6y7r91rh0lj8b6xdv3s3yknmvjc7y60v17kszgqnr887bvpn";
    "4.5-412" = "sha256:0i5c3rfzinmwdjya7gv94zyknsm32qx9dlg472xpfqivwvnnhf1z";
    "4.5-413" = "sha256:1sphq9anfg1qzrvj7hdcqflj6cmc1qiyfkljhng9fxnnr0i7550s";
    "4.5-414" = "sha256:13h588kwih05zd9p3p7q528q4zc0d1l983kkvbmkxgay5d17nn1i";
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
  ] ++ lib.optional (lib.versionOlder ocaml.version "4.12")
    # This fixes the test-suite on macOS
    # See https://github.com/ocaml/merlin/pull/1399
    # Fixed in 4.4 for OCaml ≥ 4.12
    ./test.patch
  ;

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
