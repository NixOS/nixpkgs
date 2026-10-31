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
}:
let
  mkCombyPackage =
    {
      pname,
      extraBuildInputs ? [ ],
      extraNativeInputs ? [ ],
      preConfigure ? "",
    }:
    ocamlPackages.buildDunePackage {
      inherit pname preConfigure;
      version = "1.8.1-unstable-2026-06-08";
      doCheck = true;

      src = fetchFromGitHub {
        owner = "comby-tools";
        repo = "comby";
        rev = "3b6bdff7bc3b50361b621da9db030152772e7e6b";
        hash = "sha256-1BbsHnvJ/h99zZb5qKlQpXMsV5xW0idpJWt/SQEOd6M=";
      };

      nativeBuildInputs = extraNativeInputs;

      buildInputs = [
        ocamlPackages.core
        ocamlPackages.core_kernel
        ocamlPackages.core_unix
        ocamlPackages.ppx_deriving
        ocamlPackages.ppx_deriving_yojson
      ]
      ++ extraBuildInputs;

      nativeCheckInputs = [ cacert ];

      meta = {
        description = "Tool for searching and changing code structure";
        mainProgram = "comby";
        license = lib.licenses.asl20;
        homepage = "https://comby.dev";
      };
    };

  combyKernel = mkCombyPackage {
    pname = "comby-kernel";
    extraBuildInputs = [
      ocamlPackages.ocaml_pcre
      ocamlPackages.bigstringaf
    ];
    # tests cannot be built until all of comby is built
    preConfigure = ''
      rm src test -r
    '';

  };
  combySemantic = mkCombyPackage {
    pname = "comby-semantic";
    extraBuildInputs = [ ocamlPackages.cohttp-lwt-unix ];
    # tests cannot be built until all of comby is built
    preConfigure = ''
      rm src test -r
    '';

  };
in
mkCombyPackage {
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
    ocamlPackages.parany
    ocamlPackages.conduit-lwt-unix
    ocamlPackages.lwt_react
    ocamlPackages.tar-unix
    ocamlPackages.ocaml_pcre
    ocamlPackages.cstruct-lwt
    ocamlPackages.dune-configurator
    combyKernel
    combySemantic
  ];

  extraNativeInputs = [
    autoconf
    pkg-config
  ];

}
