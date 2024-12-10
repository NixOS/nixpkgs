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
    }:
    ocamlPackages.buildDunePackage rec {
      inherit pname preBuild;
      version = "1.8.1";
      duneVersion = "3";
      minimalOcamlVersion = "4.08.1";
      doCheck = true;

      src = fetchFromGitHub {
        owner = "comby-tools";
        repo = "comby";
        rev = version;
        sha256 = "sha256-yQrfSzJgJm0OWJxhxst2XjZULIVHeEfPMvMIwH7BYDc=";
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
      --replace "test_cli_list" "" \
      --replace "test_cli_helper" "" \
      --replace "test_cli" ""
    rm test/common/{test_cli_list,test_cli_helper,test_cli}.ml
  '';

  extraBuildInputs = [
    zlib
    gmp
    libev
    sqlite
    ocamlPackages.shell # This input must appear before `parany` or any other input that propagates `ocamlnet`
    ocamlPackages.lwt
    ocamlPackages.patience_diff
    ocamlPackages.toml
    ocamlPackages.cohttp-lwt-unix
    ocamlPackages.opium
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
  ] ++ (if !stdenv.isAarch32 && !stdenv.isAarch64 then [ ocamlPackages.hack_parallel ] else [ ]);

  extraNativeInputs = [
    autoconf
    pkg-config
  ];

}
