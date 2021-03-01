{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry
, pytest-cov
, pytest-flakes
, pytest-mock
, pytest-socket
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "url-normalize";
  version = "1.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "niksite";
    repo = pname;
    rev = version;
    sha256 = "09nac5nh94x0n4bfazjfxk96b20mfsx6r1fnvqv85gkzs0rwqkaq";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ six ];

  checkInputs = [
    pytest-cov
    pytest-flakes
    pytest-mock
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "url_normalize" ];

  meta = with lib; {
    description = "URL normalization for Python";
    homepage = "https://github.com/niksite/url-normalize";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
