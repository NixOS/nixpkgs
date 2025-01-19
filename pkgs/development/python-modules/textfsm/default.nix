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
  version = "1.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IHgKG8v0X+LSK6purWBdwDnI/BCs5XA12ZJixuqqXWg=";
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

  meta = {
    description = "Python module for parsing semi-structured text into python tables";
    mainProgram = "textfsm";
    homepage = "https://github.com/google/textfsm";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
