{ buildPythonPackage
, lib
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "5.2.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G4Dn6iZLVOovzfEt9eMzp93mTX+bo0tHI5cCbaJLxBQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A wrapper around the stdlib `tokenize` which roundtrips";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
