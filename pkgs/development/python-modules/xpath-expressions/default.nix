{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lxml
, poetry-core
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xpath-expressions";
  version = "1.1.0";
<<<<<<< HEAD
  format = "pyproject";
  disabled = pythonOlder "3.5";
=======
  disabled = pythonOlder "3.5";
  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UAzDXrz1Tr9/OOjKAg/5Std9Qlrnizei8/3XL3hMSFA=";
  };

  patches = [
    # https://github.com/orf/xpath-expressions/pull/4
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/orf/xpath-expressions/commit/3c5900fd6b2d08dd9468707f35ab42072cf75bd3.patch";
      hash = "sha256-IeV6ncJyt/w2s5TPpbM5a3pljNT6Bp5PIiqgTg2iTRA=";
    })
  ];

=======
    sha256 = "0l289iw2zmzxyfi3g2z7b917vmsaz47h5jp871zvykpmpigc632h";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    # Was fixed upstream but not released
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "xpath" ];

  meta = with lib; {
    description = "Python module to handle XPath expressions";
    homepage = "https://github.com/orf/xpath-expressions";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
