{ buildPythonPackage
, fetchFromGitHub
, lib
, pandas
, pytestCheckHook
, pytorch
, tensorflow-tensorboard
, torchvision
}:

let
  version = "0.3.1";
  repo = fetchFromGitHub {
    owner = "pytorch";
    repo = "kineto";
    rev = "v${version}";
    hash = "sha256-Yg001XzOPDmz9wEP2b7Ggz/uU6x5PFzaaBeUBwWKFS0=";
  };
in
buildPythonPackage rec {
  pname = "torch_tb_profiler";
  inherit version;
  format = "setuptools";

  # See https://discourse.nixos.org/t/extracting-sub-directory-from-fetchgit-or-fetchurl-or-any-derivation/8830.
  src = "${repo}/tb_plugin";

  propagatedBuildInputs = [ pandas tensorflow-tensorboard ];

  checkInputs = [ pytestCheckHook pytorch torchvision ];

  disabledTests = [
    # Tests that attempt to access the filesystem in naughty ways.
    "test_profiler_api_without_gpu"
    "test_tensorboard_end2end"
    "test_tensorboard_with_path_prefix"
    "test_tensorboard_with_symlinks"
  ];

  pythonImportsCheck = [ "torch_tb_profiler" ];

  meta = with lib; {
    description = "PyTorch Profiler TensorBoard Plugin";
    homepage = "https://github.com/pytorch/kineto";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
