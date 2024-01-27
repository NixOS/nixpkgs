{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, which
# runtime dependencies
, numpy
, torch
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
  version = "0.03";
in
buildPythonPackage {
  pname = "xformers";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    rev = "refs/tags/v${version}";
    hash = "sha256-G8f7tny5B8SAQ6+2uOjhY7nD0uOT4sskIwtTdwivQXo=";
    fetchSubmodules = true;
  };

  preBuild = ''
    cat << EOF > ./xformers/version.py
    # noqa: C801
    __version__ = "${version}"
    EOF
  '';

  nativeBuildInputs = [
    which
  ];

  propagatedBuildInputs = [
    numpy
    torch
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
