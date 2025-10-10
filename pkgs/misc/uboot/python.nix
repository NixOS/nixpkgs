{
  lib,
  python3Packages,
  fetchPypi,
  makeWrapper,

  armTrustedFirmwareTools,
  bzip2,
  cbfstool,
  gzip,
  lz4,
  lzop,
  openssl,
  ubootTools,
  vboot_reference,
  xilinx-bootgen,
  xz,
  zstd,
}:

let
  # We are fetching from PyPI because the code in the repository seems to be
  # lagging behind the PyPI releases somehow...
  version = "0.0.7";
in
rec {

  u_boot_pylib = python3Packages.buildPythonPackage rec {
    pname = "u_boot_pylib";
    inherit version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-A5r20Y8mgxhOhaKMpd5MJN5ubzPbkodAO0Tr0RN1SRA=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    checkPhase = ''
      ${python3Packages.python.interpreter} "src/$pname/__main__.py"
      # There are some tests in other files, but they are broken
    '';

    pythonImportsCheck = [ "u_boot_pylib" ];
  };

  dtoc = python3Packages.buildPythonPackage rec {
    pname = "dtoc";
    inherit version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-NA96CznIxjqpw2Ik8AJpJkJ/ei+kQTCUExwFgssV+CM=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies =
      (with python3Packages; [
        libfdt
      ])
      ++ [
        u_boot_pylib
      ];

    pythonImportsCheck = [ "dtoc" ];
  };

  binman =
    let
      btools = [
        armTrustedFirmwareTools
        bzip2
        cbfstool
        # TODO: cst
        gzip
        lz4
        # TODO: lzma_alone
        lzop
        openssl
        ubootTools
        vboot_reference
        xilinx-bootgen
        xz
        zstd
      ];
    in
    python3Packages.buildPythonApplication rec {
      pname = "binary_manager";
      inherit version;
      pyproject = true;

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-llEBBhUoW5jTEQeoaTCjZN8y6Kj+PGNUSB3cKpgD06w=";
      };

      patches = [
        ./binman-resources.patch
      ];
      patchFlags = [
        "-p2"
        "-d"
        "src"
      ];

      build-system = with python3Packages; [
        setuptools
      ];

      nativeBuildInputs = [ makeWrapper ];

      dependencies =
        (with python3Packages; [
          jsonschema
          pycryptodomex
          pyelftools
          yamllint
        ])
        ++ [
          dtoc
          u_boot_pylib
        ];

      preFixup = ''
        wrapProgram "$out/bin/binman" --prefix PATH : "${lib.makeBinPath btools}"
      '';
    };

  patman = python3Packages.buildPythonApplication rec {
    pname = "patch_manager";
    inherit version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-zD9e87fpWKynpUcfxobbdk6wbM6Ja3f8hEVHS7DGIKQ=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies =
      (with python3Packages; [
        aiohttp
        pygit2
      ])
      ++ [
        u_boot_pylib
      ];
  };

}
