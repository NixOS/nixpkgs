{ lib, stdenv, buildPythonPackage, fetchPypi
, itsdangerous, hypothesis
, pytestCheckHook, requests
, pytest-timeout
, isPy3k
 }:

buildPythonPackage rec {
  pname = "Werkzeug";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
  };

  propagatedBuildInputs = [ itsdangerous ];
  checkInputs = [ pytestCheckHook requests hypothesis pytest-timeout ];

  disabledTests = [
    "test_save_to_pathlib_dst"
    "test_cookie_maxsize"
    "test_cookie_samesite_attribute"
    "test_cookie_samesite_invalid"
    "test_range_parsing"
    "test_content_range_parsing"
    "test_http_date_lt_1000"
    "test_best_match_works"
    "test_date_to_unix"
    "test_easteregg"

    # Seems to be a problematic test-case:
    #
    # > warnings.warn(pytest.PytestUnraisableExceptionWarning(msg))
    # E pytest.PytestUnraisableExceptionWarning: Exception ignored in: <_io.FileIO [closed]>
    # E
    # E Traceback (most recent call last):
    # E   File "/nix/store/cwv8aj4vsqvimzljw5dxsxy663vjgibj-python3.9-Werkzeug-1.0.1/lib/python3.9/site-packages/werkzeug/formparser.py", line 318, in parse_multipart_headers
    # E     return Headers(result)
    # E ResourceWarning: unclosed file <_io.FileIO name=11 mode='rb+' closefd=True>
    "TestMultiPart"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_get_machine_id"
  ];

  meta = with lib; {
    homepage = "https://palletsprojects.com/p/werkzeug/";
    description = "A WSGI utility library for Python";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
