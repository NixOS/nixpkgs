{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonAtLeast
, pythonOlder
, idna
, multidict
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
  version = "1.8.2";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SdQ0AsbjATrQl4YCv2v1MoU1xI0ZIwS5G5ejxnkLFWI=";
  };

  patches = [
    # https://github.com/aio-libs/yarl/issues/876
    (fetchpatch {
      url = "https://github.com/aio-libs/yarl/commit/0a94c6e4948e00fff072c0cf367afbf4ac36f906.patch";
      hash = "sha256-bqT46OLZLkBef8FQ1L95ITD70mC3+WIkr3+h2ekKrvE=";
    })
  ];

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  propagatedBuildInputs = [
    idna
    multidict
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  preCheck = ''
    # don't import yarl from ./ so the C extension is available
    pushd tests
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_not_a_scheme2"
  ];

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "yarl" ];

  meta = with lib; {
    changelog = "https://github.com/aio-libs/yarl/blob/v${version}/CHANGES.rst";
    description = "Yet another URL library";
    homepage = "https://github.com/aio-libs/yarl";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
