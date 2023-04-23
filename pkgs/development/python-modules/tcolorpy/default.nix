{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tcolorpy";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-duMbeKygEuGVcg4+gQRfClww3rs5AsmJR1VQBo7KWFY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tcolorpy";
    description = "A library to apply true color for terminal text";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
