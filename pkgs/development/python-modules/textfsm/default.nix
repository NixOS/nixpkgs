{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  future,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textfsm";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-YMoo6vGZ0sFhtgKgmLW+j8bEt0I6WymXgvPSXiN9OKA=";
  };

  # upstream forgot to update the release version
  postPatch = ''
    substituteInPlace textfsm/__init__.py \
      --replace "1.1.2" "1.1.3"
  '';

  propagatedBuildInputs = [
    six
    future
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python module for parsing semi-structured text into python tables";
    mainProgram = "textfsm";
    homepage = "https://github.com/google/textfsm";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
