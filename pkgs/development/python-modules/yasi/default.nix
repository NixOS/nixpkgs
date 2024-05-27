{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yasi";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkmathew";
    repo = "yasi-sexp-indenter";
    rev = "v${version}";
    hash = "sha256-xKhVTmh/vrtBkatxtk8R4yqbGroH0I+xTKNYUpuikt4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "test.test_yasi" "tests.test_yasi"
  '';

  pythonImportsCheck = [ "yasi" ];

  meta = with lib; {
    description = "A dialect-aware s-expression indenter written in Python and newLISP";
    mainProgram = "yasi";
    homepage = "https://github.com/nkmathew/yasi-sexp-indenter";
    changelog = "https://github.com/nkmathew/yasi-sexp-indenter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
