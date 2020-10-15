{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest
, pytestrunner
, pytestCheckHook
, pytorch
}:

buildPythonPackage rec {
  pname = "torchgpipe";
  version = "0.0.7";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kakaobrain";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ki0njhmz1i3pkpr3y6h6ac7p5qh1kih06mknc2s18mfw34f2l55";
  };

  propagatedBuildInputs = [ pytorch ];

  checkInputs = [ pytest pytestrunner pytestCheckHook ];
  disabledTests = [ "test_inplace_on_requires_grad" ];
  # seems like a harmless failure:
  ## AssertionError:
  ## Pattern 'a leaf Variable that requires grad has been used in an in-place operation.'
  ## does not match 'a leaf Variable that requires grad is being used in an in-place operation.'

  meta = with lib; {
    description = "GPipe implemented in Pytorch and optimized for CUDA rather than TPU";
    homepage = "https://torchgpipe.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
