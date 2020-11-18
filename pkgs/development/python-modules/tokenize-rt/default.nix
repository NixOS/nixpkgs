{ lib
, isPy27
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "4.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hd08lyh6bl92lpf4pswz28134dwzv5254myzxymlvpf9wnck9fm";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/asottile/tokenize-rt";
    description = "This library is useful if you're writing a refactoring tool based on the python tokenization.";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
