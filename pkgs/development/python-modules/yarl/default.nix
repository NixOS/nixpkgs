{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonAtLeast
, pythonOlder
, idna
, multidict
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yarl";
<<<<<<< HEAD
  version = "1.9.2";
=======
  version = "1.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BKudS59YfAbYAcKr/pMXt3zfmWxlqQ1ehOzEUBCCNXE=";
  };

  patches = [
    # https://github.com/aio-libs/yarl/issues/876
    (fetchpatch {
      url = "https://github.com/aio-libs/yarl/commit/0a94c6e4948e00fff072c0cf367afbf4ac36f906.patch";
      hash = "sha256-bqT46OLZLkBef8FQ1L95ITD70mC3+WIkr3+h2ekKrvE=";
    })
  ];

=======
    hash = "sha256-SdQ0AsbjATrQl4YCv2v1MoU1xI0ZIwS5G5ejxnkLFWI=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_not_a_scheme2"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
