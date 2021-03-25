{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchPypi
, pytest-cov
, pytestCheckHook
, six
, tox
}:

buildPythonPackage rec {
  pname = "tld";
  version = "0.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1lbbg2qdw5jjxks0dqlf69bki5885mhj8ysvgylmrni56hjqqv";
  };

  checkInputs = [
    factory_boy
    faker
    pytest-cov
    pytestCheckHook
    tox
  ];

  pythonImportsCheck = [ "tld" ];

  meta = with lib; {
    homepage = "https://github.com/barseghyanartur/tld";
    description = "Extracts the top level domain (TLD) from the URL given";
    # https://github.com/barseghyanartur/tld/blob/master/README.rst#license
    # MPL-1.1 OR GPL-2.0-only OR LGPL-2.1-or-later
    license = with licenses; [ lgpl21Plus mpl11 gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
