{ stdenv, fetchFromGitHub, fetchurl, buildDunePackage, ocamlPackages, esy-solve-cudf, reason, coreutils, makeWrapper, buildFHSUserEnv, glibc, lib, runtimeShell, writeScript }:
let
  fhsEnv = buildFHSUserEnv {
    name = "esy-fhs-env";
    multiPkgs = pkgs:
      with pkgs; [
        bash
        stdenv.cc
        coreutils
        gnumake
        curl
        git
        perl # for shasum
        m4
        binutils
        gnupatch
        unzip
      ];
    runScript = writeScript "esy-run" ''
      #!${runtimeShell}
      run="$1"
      if [ "$run" = "" ]; then
        echo "Usage: esy-run command-to-run args..." >&2
        exit 1
      fi
      shift
      exec -- "$run" "$@"
    '';
  };
in
buildDunePackage rec {
  pname = "esy";
  version = "0.6.6";

  srcs = [
    (fetchFromGitHub {
      owner = "esy";
      repo = "esy";
      rev = "v${version}";
      sha256 = "17jqc1jj6fmmr9js1vks3fpl2969xmd9n9bhgh7cihwmlwdrs2j6";
    })
    (fetchurl {
      url = "https://registry.npmjs.org/esy/${version}";
      sha256 = "1j55l860gkg2zbdwlr5xg4vkpjw6zds68cjk9gz069w18gfr8qis";
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
    makeWrapper
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
    chmod +x $out/lib/default/bin/esy.exe
    makeWrapper ${fhsEnv}/bin/esy-fhs-env $out/bin/esy \
      --add-flags "$out/lib/default/bin/esy.exe"
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
