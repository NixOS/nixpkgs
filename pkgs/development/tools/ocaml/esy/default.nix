{ stdenv, fetchFromGitHub, fetchurl, buildDunePackage, ocamlPackages, esy-solve-cudf, reason }:

buildDunePackage rec {
  pname = "esy";
  version = "0.6.2";

  srcs = [
    (fetchFromGitHub {
      owner = "esy";
      repo = "esy";
      rev = "v${version}";
      sha256 = "1k2mlykgldm17akk9f7g8na68w7kshffnkpnhbawpk6bczh6xjmx";
    })
    (fetchurl {
      url = "https://registry.npmjs.org/esy/${version}";
      sha256 = "0byqaby0x54cmrhgsk4p8p4nz2f6cqdxkk2zdz10aja89rp0pj0l";
    })
  ];

  # causes https://github.com/kamilchm/nix-esy/issues/1
  patches = [
    (fetchurl {
      url = "https://patch-diff.githubusercontent.com/raw/esy/esy/pull/988.patch";
      sha256 = "1cx1f806g8mzhv183cxj7cl8cxfq967ls8pafgdilssg4aj26mj4";
    })
  ];

  postPatch = ''
    substituteInPlace esy-build/Scope.re \
      --replace "/bin/bash" "/usr/bin/env bash"
    substituteInPlace esy-install/Fetch.re \
      --replace "/bin/bash" "/usr/bin/env bash"
    substituteInPlace bin/Project.re \
      --replace "/bin/bash" "/usr/bin/env bash"
    substituteInPlace bin/esy.re \
      --replace "/bin/bash" "/usr/bin/env bash"
  '';

  outputs = [ "out" "npm" ];

  unpackPhase = '' # basically the default unpackPhase, just only on first source
    runHook preUnpack
    set -- $srcs
    unpackFile $1
    sourceRoot="source"
    chmod -R u+w -- $sourceRoot
    runHook postUnpack
  '';

  useDune2 = true;

  buildInputs = with ocamlPackages; [
    angstrom
    astring
    bos
    cmdliner
    cudf
    dose3
    dune-configurator
    fmt
    logs
    lwt_ppx
    opam-file-format
    opam-format
    opam-state
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    ppx_here
    ppx_inline_test
    ppx_let
    ppx_sexp_conv
    ppxlib
    re
    reason
    rresult
    yojson
  ];

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname},${pname}-build-package
    runHook postBuild
  '';

  # |- bin
  #   |- esy
  # |- lib
  #   |- default
  #     |- bin
  #       |- esy.exe
  #       |- esyInstallRelease.js
  #     |- esy-build-package
  #       |- bin
  #       |- esyBuildPackageCommand.exe
  #       |- esyRewritePrefixCommand.exe
  #   |- node_modules
  #     |- esy-solve-cudf
  #       |- package.json
  #       |- esySolveCudfCommand.exe
  # |- package.json

  postInstall = ''
    mkdir -p $out/lib/default/bin
    mkdir -p $out/lib/default/esy-build-package/bin
    mkdir -p $out/lib/node_modules/esy-solve-cudf
    mv $out/bin/esy $out/lib/default/bin/esy.exe
    mv $out/bin/esyInstallRelease.js $out/lib/default/bin/
    mv $out/bin/esy-build-package $out/lib/default/esy-build-package/bin/esyBuildPackageCommand.exe
    mv $out/bin/esy-rewrite-prefix $out/lib/default/esy-build-package/bin/esyRewritePrefixCommand.exe
    ln -s $out/lib/default/bin/esy.exe $out/bin/esy
    set -- $srcs
    cp $2 $out/package.json

    # install esy-solve-cudf dependency
    cp ${esy-solve-cudf}/bin/esy-solve-cudf $out/lib/node_modules/esy-solve-cudf/esySolveCudfCommand.exe
    cp ${esy-solve-cudf.npm}/package.json $out/lib/node_modules/esy-solve-cudf/package.json

    mkdir $npm
    cp $2 $npm/package.json
  '';

  meta = {
    description = "package.json workflow for native development with Reason/OCaml";
    license = stdenv.lib.licenses.bsd2;
    homepage = "https://esy.sh";
  };
}
