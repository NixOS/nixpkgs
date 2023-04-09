{ lib
, buildPythonApplication
, colorama
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "yasi";
  version = "2.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nkmathew";
    repo = "yasi-sexp-indenter";
    rev = "v${version}";
    hash = "sha256-xKhVTmh/vrtBkatxtk8R4yqbGroH0I+xTKNYUpuikt4=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "test.test_yasi" "tests.test_yasi"
  '';

  pythonImportsCheck = [ "yasi" ];

  meta = with lib; {
    description = "A dialect-aware s-expression indenter written in Python and newLISP";
    homepage = "https://github.com/nkmathew/yasi-sexp-indenter";
    changelog = "https://github.com/nkmathew/yasi-sexp-indenter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
