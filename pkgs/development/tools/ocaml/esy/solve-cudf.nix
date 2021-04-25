{ stdenv, fetchurl, fetchFromGitHub, buildDunePackage, ocamlPackages }:

buildDunePackage rec {
  pname = "esy-solve-cudf";
  version = "0.1.10";

  srcs = [
    (fetchFromGitHub {
      owner = "andreypopp";
      repo = "esy-solve-cudf";
      rev = "d293f2116def0b0b02eef487158ae440d21cc8db";
      sha256 = "174q1wkr31dn8vsvnlj4hzfgvbamqq74n7wxhbccriqmv8lz5a3g";
      fetchSubmodules = true;
    })
    (fetchurl {
      url = "https://registry.npmjs.org/esy-solve-cudf/${version}";
      sha256 = "19m793mydd8gcgw1mbn7pd8fw2rhnd00k5wpa4qkx8a3zn6crjjf";
    })
  ];

  outputs = [ "out" "npm" ];

  buildInputs = with ocamlPackages; [ ocaml findlib ];
  propagatedBuildInputs = with ocamlPackages; [ cmdliner cudf ocaml_extlib ];

  unpackPhase = '' # basically the default unpackPhase, just only on first source
    runHook preUnpack
    set -- $srcs
    unpackFile $1
    sourceRoot="source"
    chmod -R u+w -- $sourceRoot
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname},mccs
    runHook postBuild
  '';

  postInstall = ''
    mkdir $npm
    set -- $srcs
    cp $2 $npm/package.json
  '';

  meta = {
    homepage = https://github.com/andreypopp/esy-solve-cudf;
    description = "package.json workflow for native development with Reason/OCaml";
    license = stdenv.lib.licenses.gpl3;
  };
}

