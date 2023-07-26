{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pythonRelaxDepsHook
, which
# runtime dependencies
, numpy
, torch
, pyre-extensions
# check dependencies
, pytestCheckHook
, pytest-cov
# , pytest-mpi
, pytest-timeout
# , pytorch-image-models
, hydra-core
, fairscale
, scipy
, cmake
, openai-triton
, networkx
#, apex
, einops
, transformers
, timm
#, flash-attn
}:
let
  version = "0.0.21";
in
buildPythonPackage {
  pname = "xformers";
  inherit version;
  format = "setuptools";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    rev = "v${version}";
    hash = "sha256-zYziynjLtqjPPHjDbruuuG9209y0Sh+wYUFHUj+QG2Y=";
    fetchSubmodules = true;
  };

  preBuild = ''
    cat << EOF > ./xformers/version.py
    # noqa: C801
    __version__ = "${version}"
    EOF
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    which
  ];

  pythonRelaxDeps = [
    "pyre-extensions"
  ];

  propagatedBuildInputs = [
    numpy
    torch
    pyre-extensions
  ];

  pythonImportsCheck = [ "xformers" ];

  dontUseCmakeConfigure = true;

  # see commented out missing packages
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    pytest-timeout
    hydra-core
    fairscale
    scipy
    cmake
    networkx
    openai-triton
    # apex
    einops
    transformers
    timm
    # flash-attn
  ];

  meta = with lib; {
    description = "XFormers: A collection of composable Transformer building blocks";
    homepage = "https://github.com/facebookresearch/xformers";
    changelog = "https://github.com/facebookresearch/xformers/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ happysalada ];
  };
}
