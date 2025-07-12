{
  ocamlPackages,
  fetchFromGitHub,
  lib,
  zlib,
  pkg-config,
  cacert,
  gmp,
  libev,
  autoconf,
  sqlite,
  stdenv,
}:
let
  mkCombyPackage =
    {
      pname,
      extraBuildInputs ? [ ],
      extraNativeInputs ? [ ],
      preBuild ? "",
      doCheck ? true,
    }:
    ocamlPackages.buildDunePackage rec {
      inherit pname preBuild doCheck;
      version = "1.8.2";
      minimalOCamlVersion = "4.08.1";

      src = fetchFromGitHub {
        owner = "comby-tools";
        repo = "comby";
        rev = "3e4dc0c9600f7fb0d7357e2f78c3ad9871a02320";
        hash = "sha256-MfsqZW3YDyr5bOyYVWAurOZzjV+RLO9q8BSNCki4Dwc=";
      };

      patches = [ ./comby.patch ];

      nativeBuildInputs = extraNativeInputs;

      buildInputs = [
        ocamlPackages.core
        ocamlPackages.core_kernel
        ocamlPackages.ocaml_pcre
        ocamlPackages.mparser
        ocamlPackages.mparser-pcre
        ocamlPackages.angstrom
        ocamlPackages.ppx_deriving
        ocamlPackages.ppx_deriving_yojson
        ocamlPackages.ppx_sexp_conv
        ocamlPackages.ppx_sexp_message
      ] ++ extraBuildInputs;

      nativeCheckInputs = [ cacert ];

      meta = {
        description = "Tool for searching and changing code structure";
        mainProgram = "comby";
        license = lib.licenses.asl20;
        homepage = "https://comby.dev";
      };
    };

  combyKernel = mkCombyPackage { pname = "comby-kernel"; };
  combySemantic = mkCombyPackage {
    pname = "comby-semantic";
    extraBuildInputs = [ ocamlPackages.cohttp-lwt-unix ];
  };
in
mkCombyPackage {
  pname = "comby";

  # tests have to be removed before building otherwise installPhase will fail
  # cli tests expect a path to the built binary
  preBuild = ''
    substituteInPlace test/common/dune \
      --replace-warn "test_cli_list" "" \
      --replace-warn "test_cli_helper" "" \
      --replace-warn "test_cli" ""
    rm test/common/{test_cli_list,test_cli_helper,test_cli}.ml
  '';

  doCheck = false;

  extraBuildInputs =
    [
      zlib
      gmp
      libev
      sqlite
      ocamlPackages.shell # This input must appear before `parany` or any other input that propagates `ocamlnet`
      ocamlPackages.lwt
      ocamlPackages.patience_diff
      ocamlPackages.toml
      ocamlPackages.cohttp-lwt-unix
      ocamlPackages.textutils
      ocamlPackages.jst-config
      ocamlPackages.parany
      ocamlPackages.conduit-lwt-unix
      ocamlPackages.lwt_react
      ocamlPackages.tar-unix
      ocamlPackages.tls
      ocamlPackages.ppx_jane
      ocamlPackages.ppx_expect
      ocamlPackages.dune-configurator
      combyKernel
      combySemantic
    ]
    ++ (
      if !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isAarch64 then
        [ ocamlPackages.hack_parallel ]
      else
        [ ]
    );

  extraNativeInputs = [
    autoconf
    pkg-config
  ];

}
