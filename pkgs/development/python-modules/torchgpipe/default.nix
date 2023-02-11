{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, torch
}:

buildPythonPackage rec {
  pname = "torchgpipe";
  version = "0.0.7";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kakaobrain";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ki0njhmz1i3pkpr3y6h6ac7p5qh1kih06mknc2s18mfw34f2l55";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  propagatedBuildInputs = [ torch ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    "test_inplace_on_requires_grad"
    "test_input_requiring_grad"
  ];

  meta = with lib; {
    description = "GPipe implemented in Pytorch and optimized for CUDA rather than TPU";
    homepage = "https://torchgpipe.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
