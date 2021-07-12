{ buildPythonPackage
, lib
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9qamHk2IZRmgGNFlYkSRks6mRVNlYfetpK/7rsfK9tc=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A wrapper around the stdlib `tokenize` which roundtrips";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
