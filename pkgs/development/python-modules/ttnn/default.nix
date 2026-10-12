{
  lib,
  buildPythonPackage,
  python,
  pythonOlder,
  tt-metal,
  setuptools,
  setuptools-scm,
  click,
  graphviz,
  loguru,
  ml-dtypes,
  networkx,
  numpy,
  pandas,
  pyyaml,
  seaborn,
}:

let
  tt-metal' = tt-metal.override { python3 = python; };
in

buildPythonPackage {
  pname = "ttnn";
  inherit (tt-metal') version src;
  pyproject = true;
  __structuredAttrs = true;

  # nanobind builds _ttnn.so against the stable ABI targeting python 3.12+
  disabled = pythonOlder "3.12";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.10.2" "setuptools" \
      --replace-fail "setuptools-scm==8.1.0" "setuptools-scm"
  '';

  preBuild = ''
    mkdir -p build/lib64 runtime
    for f in _ttnn.so _ttnncpp.so libtt_metal.so libtt_stl.so; do
      cp ${tt-metal'}/lib/$f build/lib64/
    done
    cp -P ${tt-metal'}/lib/libtt-umd.so* build/lib64/
    ln -sfn lib64 build/lib

    cp -r --no-preserve=ownership,mode ${tt-metal'}/libexec/tt-metalium/runtime/hw runtime/hw

    export TT_FROM_PRECOMPILED_DIR="$PWD"
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = tt-metal'.version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    click
    graphviz
    loguru
    ml-dtypes
    networkx
    numpy
    pandas
    pyyaml
    seaborn
  ];

  postInstall = ''
    mkdir -p $out/${python.sitePackages}/ttnn/runtime
    ln -s ${tt-metal'.sfpi} $out/${python.sitePackages}/ttnn/runtime/sfpi
  '';

  pythonImportsCheck = [ "ttnn" ];

  meta = {
    description = "Python library and operator framework for Tenstorrent devices (TT-NN)";
    homepage = "https://github.com/tenstorrent/tt-metal";
    changelog = "https://github.com/tenstorrent/tt-metal/releases/tag/v${tt-metal'.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ liberodark ];
  };
}
