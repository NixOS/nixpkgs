{ ocamlPackages, fetchFromGitHub, lib, zlib, pkg-config, cacert, gmp, libev
, autoconf, sqlite, stdenv }:
let
  mkCombyPackage = { pname, extraBuildInputs ? [ ], extraNativeInputs ? [ ] }:
    ocamlPackages.buildDunePackage rec {
      inherit pname;
      version = "1.5.1";
      useDune2 = true;
      minimumOcamlVersion = "4.08.1";
      doCheck = true;

      src = fetchFromGitHub {
        owner = "comby-tools";
        repo = "comby";
        rev = version;
        sha256 = "1ipfrr6n1jyyryhm9zpn8wwgzfac1zgbjdjzrm00qcwc17r8x2hf";
      };

      nativeBuildInputs = [
        ocamlPackages.ppx_deriving
        ocamlPackages.ppx_deriving_yojson
        ocamlPackages.ppx_sexp_conv
        ocamlPackages.ppx_sexp_message
      ] ++ extraNativeInputs;

      buildInputs = [
        ocamlPackages.core
        ocamlPackages.ocaml_pcre
        ocamlPackages.mparser
        ocamlPackages.mparser-pcre
        ocamlPackages.angstrom
      ] ++ extraBuildInputs;

      checkInputs = [ cacert ];

      meta = {
        description = "Tool for searching and changing code structure";
        license = lib.licenses.asl20;
        homepage = "https://comby.dev";
      };
    };

  combyKernel = mkCombyPackage { pname = "comby-kernel"; };
in mkCombyPackage {
  pname = "comby";

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
    ocamlPackages.tls
    combyKernel
  ] ++ (if !stdenv.isAarch32 && !stdenv.isAarch64 then
    [ ocamlPackages.hack_parallel ]
  else
    [ ]);

  extraNativeInputs = [
    autoconf
    pkg-config
    ocamlPackages.ppx_jane
    ocamlPackages.ppx_expect
    ocamlPackages.dune-configurator
  ];
}
