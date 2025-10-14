{
  stdenv,
  buildPythonPackage,
  autoPatchelfHook,
  tt-metal,
  python,
  setuptools,
  setuptools-scm,
  numpy,
  loguru,
  networkx,
  graphviz,
  click,
  pyyaml,
  pydantic,
}:
buildPythonPackage {
  pname = "ttnn";

  inherit (tt-metal) src version;

  pyproject = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    # For libstdc++
    stdenv.cc.cc
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    loguru
    networkx
    graphviz
    click
    pyyaml
    pydantic
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==70.1.0" "setuptools>=70.1.0" \
      --replace-fail "setuptools-scm==8.1.0" "setuptools-scm>=8.1.0"

    patchShebangs build_metal.sh

    export TT_FROM_PRECOMPILED_DIR=$(pwd)

    cp -r ${tt-metal.build} build
    chmod -R u+w build

    cp ${tt-metal}/lib/_ttnn.so build/lib/

    ln -s ${tt-metal}/libexec/tt-metalium/runtime runtime

    sed -i 's|/opt/tenstorrent/sfpi|${tt-metal.sfpi}|g' ttnn/ttnn/library_tweaks.py
  '';

  postInstall = ''
    patchelf --remove-rpath $out/${python.sitePackages}/ttnn/_ttnn.cpython-*
    patchelf --add-rpath ${tt-metal}/lib $out/${python.sitePackages}/ttnn/_ttnn.cpython-*

    # Needs to be empty so nobody gets a "ModuleNotFoundError: No module named 'tt_metal'"
    echo "" > $out/${python.sitePackages}/tracy/__init__.py
  '';

  meta = tt-metal.meta // {
    description = "Open source library of neural network operations built on the tt-metal programming model";
  };
}
